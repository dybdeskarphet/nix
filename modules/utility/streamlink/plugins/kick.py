"""
$description Global live-streaming and video hosting social platform owned by Kick Streaming Pty Ltd.
$url kick.com
$type live, vod
$webbrowser Required for solving a JS challenge that allows access to the Kick API
$metadata id
$metadata author
$metadata category
$metadata title
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass, replace as dataclass_replace
from datetime import datetime
from ssl import OP_NO_TICKET
from typing import ClassVar
from urllib.parse import parse_qsl, urlparse

from streamlink.exceptions import NoStreamsError
from streamlink.logger import getLogger
from streamlink.plugin import Plugin, PluginError, pluginargument, pluginmatcher
from streamlink.plugin.api import useragents, validate
from streamlink.session.http import SSLContextAdapter
from streamlink.stream.hls import (
    M3U8,
    HLSPlaylist,
    HLSSegment,
    HLSStream,
    HLSStreamReader,
    HLSStreamWorker,
    HLSStreamWriter,
    M3U8Parser,
    parse_tag,
)
from streamlink.utils.times import hours_minutes_seconds_float

# Fix CDP Cookie.from_json for modern Chromium versions that omit sameParty
try:
    from streamlink.webbrowser.cdp.devtools import network as cdp_network
    _orig_cookie_from_json = cdp_network.Cookie.from_json

    @classmethod
    def _safe_cookie_from_json(cls, json_data):
        if "sameParty" not in json_data:
            json_data = dict(json_data)
            json_data["sameParty"] = False
        return _orig_cookie_from_json(json_data)

    cdp_network.Cookie.from_json = _safe_cookie_from_json
except Exception:
    pass


log = getLogger(__name__)

LOW_LATENCY_MAX_LIVE_EDGE = 2


@dataclass(kw_only=True)
class KickHLSSegment(HLSSegment):
    prefetch: bool = False


class KickM3U8(M3U8[KickHLSSegment, HLSPlaylist]):
    pass


class KickM3U8Parser(M3U8Parser[KickM3U8, KickHLSSegment, HLSPlaylist]):
    __m3u8__: ClassVar[type[KickM3U8]] = KickM3U8
    __segment__: ClassVar[type[KickHLSSegment]] = KickHLSSegment

    @parse_tag("EXT-X-PREFETCH")
    def parse_tag_ext_x_prefetch(self, value):
        segments = self.m3u8.segments
        if not segments:  # pragma: no cover
            return
        last = segments[-1]

        # Use the average duration of all regular segments for the duration of prefetch segments.
        # This is better than using the duration of the last segment when regular segment durations vary a lot.
        # In low latency mode, the playlist reload time is the duration of the last segment.
        duration = last.duration if last.prefetch else sum(segment.duration for segment in segments) / float(len(segments))

        segment = dataclass_replace(
            last,
            uri=self.uri(value),
            duration=duration,
            title=None,
            prefetch=True,
        )
        segments.append(segment)


class KickHLSStreamWorker(HLSStreamWorker):
    reader: KickHLSStreamReader
    writer: KickHLSStreamWriter
    stream: KickHLSStream

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if self.stream.low_latency:
            self.reload_time = "segment"

    def process_segments(self, playlist: KickM3U8):  # type: ignore[override, ty:invalid-method-override]
        # ignore prefetch segments if not LL streaming
        if not self.stream.low_latency:
            playlist.segments = [segment for segment in playlist.segments if not segment.prefetch]

        return super().process_segments(playlist)


class KickHLSStreamWriter(HLSStreamWriter):
    reader: KickHLSStreamReader
    stream: KickHLSStream


class KickHLSStreamReader(HLSStreamReader):
    __worker__ = KickHLSStreamWorker
    __writer__ = KickHLSStreamWriter

    worker: KickHLSStreamWorker
    writer: KickHLSStreamWriter
    stream: KickHLSStream

    def __init__(self, stream: KickHLSStream, **kwargs):
        if stream.low_latency:
            live_edge = max(1, min(LOW_LATENCY_MAX_LIVE_EDGE, stream.session.options.get("hls-live-edge")))
            stream.session.options.set("hls-live-edge", live_edge)
            stream.session.options.set("hls-segment-stream-data", True)
            log.info(f"Low latency streaming (HLS live edge: {live_edge})")

        super().__init__(stream, **kwargs)


class KickHLSStream(HLSStream):
    __reader__ = KickHLSStreamReader
    __parser__ = KickM3U8Parser

    def __init__(self, *args, low_latency: bool = False, **kwargs):
        super().__init__(*args, **kwargs)
        self.low_latency = low_latency


class KickAdapter(SSLContextAdapter):
    def get_ssl_context(self):
        ctx = super().get_ssl_context()
        ctx.options &= ~OP_NO_TICKET

        return ctx


@pluginmatcher(
    name="live",
    pattern=re.compile(r"https?://(?:\w+\.)?kick\.com/(?!video/)(?P<channel>[^/?]+)$"),
)
@pluginmatcher(
    name="vod",
    pattern=re.compile(r"https?://(?:\w+\.)?kick\.com/(?:video/|(?P<channel>[^/]+)/videos/)(?P<vod>[^/?]+)"),
)
@pluginmatcher(
    name="clip",
    pattern=re.compile(r"https?://(?:\w+\.)?kick\.com/(?!video/)(?P<channel>[^/?]+)(?:\?clip=|/clips/)(?P<clip>[^?&]+)"),
)
@pluginargument(
    "low-latency",
    action="store_true",
    help="""
        Enables low latency streaming by prefetching HLS segments.
        Sets --hls-segment-stream-data to true and --hls-live-edge to 2, if it is higher.
        Reducing --hls-live-edge to `1` will result in the lowest latency possible, but will most likely cause buffering.

        In order to achieve true low latency streaming during playback, the player's caching/buffering settings will
        need to be adjusted and reduced to a value as low as possible, but still high enough to not cause any buffering.
        This depends on the stream's bitrate and the quality of the connection to Kick's servers. Please refer to the
        player's own documentation for the required configuration. Player parameters can be set via --player-args.

        Note: Low latency streams have to be enabled by the broadcasters on Kick themselves.
        Regular streams can cause buffering issues with this option enabled due to the reduced --hls-live-edge value.
    """,
)
class Kick(Plugin):
    _CACHE_HEADERS = "headers"
    _CACHE_EXPIRATION = 3600 * 24 * 30

    _URL_API_LIVESTREAM = "https://kick.com/api/v2/channels/{channel}/livestream"
    _URL_API_VOD = "https://kick.com/api/v1/video/{vod}"
    _URL_API_CLIP = "https://kick.com/api/v2/clips/{clip}"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.session.http.mount("https://kick.com/", KickAdapter())
        self.session.http.headers.update(self.cache.get(self._CACHE_HEADERS, {}))
        self.session.http.headers.update({
            "Referer": self.url,
        })

        parsed = urlparse(self.url)
        params = dict(parse_qsl(parsed.query))
        time_param = params.get("t") or params.get("start") or params.get("time") or "0"
        try:
            self.time_offset = hours_minutes_seconds_float(time_param)
        except Exception:
            self.time_offset = 0.0

    def _get_cookies_from_webbrowser(self) -> bool:
        # ruff: disable[import-outside-top-level]
        from streamlink.compat import BaseExceptionGroup
        from streamlink.webbrowser.cdp import CDPClient, CDPClientSession
        from streamlink.webbrowser.cdp.devtools import fetch  # ruff: ignore[typing-only-first-party-import]
        # ruff: enable[import-outside-top-level]

        async def on_main(client_session: CDPClientSession, request: fetch.RequestPaused):
            # get Chromium's request headers, update HTTP session headers and also cache them
            self.session.http.headers.update(request.request.headers)
            self.cache.set(self._CACHE_HEADERS, request.request.headers, expires=self._CACHE_EXPIRATION)
            await client_session.continue_request(request)

        async def get_challenge_cookies(client: CDPClient):
            async with client.session() as client_session:
                client_session.add_request_handler(on_main, url_pattern=self.url, on_request=True)
                async with client_session.navigate(self.url) as frame_id:
                    await client_session.loaded(frame_id)
                    await client_session.retrieve_cookies()

        log.info("Solving JS challenge")

        try:
            CDPClient.launch(self.session, get_challenge_cookies)
        except BaseExceptionGroup:
            log.exception("Failed solving JS challenge")
        except Exception as err:
            log.error(err)
        else:
            log.info("JS challenge solved, storing cookies")
            self.save_cookies()

            return True

        return False

    def _get_api_headers(self):
        # _get_cookies_from_webbrowser() from above updates the session headers with Chromium's initial request headers
        ua = str(self.session.http.headers.get("User-Agent", useragents.CHROME))
        if "Chrome/" not in ua:
            ua = useragents.CHROME

        if not (m := re.search(r"Chrome/(?P<full>(?P<main>\d+)\S+)", ua)):
            raise PluginError("Error while parsing Chromium User-Agent")

        return {
            "Accept": "application/json",
            "Accept-Language": "en-US",
            "sec-ch-ua": f'"Not:A-Brand";v="24", "Chromium";v="{m["main"]}"',
            "sec-ch-ua-arch": '"x86"',
            "sec-ch-ua-bitness": '"64"',
            "sec-ch-ua-full-version": f'"{m["full"]}"',
            "sec-ch-ua-full-version-list": f'"Not:A-Brand";v="24.0.0.0", "Chromium";v="{m["full"]}"',
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-model": '""',
            "sec-ch-ua-platform": '"Windows"',
            "sec-ch-ua-platform-version": '"6.14.0"',
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-origin",
            "sec-fetch-user": "?1",
        }

    def _query_api(self, url, schema, secondary_attempt=False):
        res = self.session.http.get(
            url,
            headers=self._get_api_headers(),
            raise_for_status=False,
        )
        if res.status_code == 403 and not secondary_attempt and self._get_cookies_from_webbrowser():
            # re-attempt API query after getting (new) cookies
            return self._query_api(url, schema, secondary_attempt=True)

        try:
            res.raise_for_status()
        except Exception as err:
            raise PluginError(f"Error while querying Kick API: {err or '403 status response'}") from err

        main_schema = validate.Schema(
            validate.parse_json(),
            validate.any(
                validate.all(
                    {"message": str},
                    validate.transform(lambda obj: ("error", obj["message"])),
                ),
                validate.all(
                    {"data": None},
                    validate.transform(lambda _: ("data", None)),
                ),
                validate.all(
                    schema,
                    validate.transform(lambda obj: ("data", obj)),
                ),
            ),
        )
        restype, data = main_schema.validate(res.text)

        if restype == "error":
            raise PluginError(f"Error while querying Kick API: {data or 'unknown error'}")
        if not data:
            raise NoStreamsError

        return data

    def _get_streams_live(self):
        self.author = self.match["channel"]

        hls_url, self.id, self.category, self.title = self._query_api(
            self._URL_API_LIVESTREAM.format(channel=self.author),
            schema=validate.Schema(
                {
                    "data": {
                        "playback_url": validate.url(path=validate.endswith(".m3u8")),
                        "id": int,
                        "category": {"name": str},
                        "session_title": str,
                    },
                },
                validate.get("data"),
                validate.union_get(
                    "playback_url",
                    "id",
                    ("category", "name"),
                    "session_title",
                ),
            ),
        )

        return KickHLSStream.parse_variant_playlist(self.session, hls_url, low_latency=self.get_option("low-latency"))

    def _extract_vod_from_html(self, html_text: str, vod_id: str):
        # Extract self.__next_f chunks (Next.js React Server Components stream)
        raw_chunks = re.findall(r'self\.__next_f\.push\(\[1,\s*"(.*?)(?<!\\)"\]\)', html_text, flags=re.DOTALL)
        chunks = []
        for c in raw_chunks:
            try:
                s = json.loads(f'"{c}"')
                chunks.append(s)
            except Exception:
                chunks.append(c.replace(r'\"', '"').replace(r'\\', '\\'))

        full_rsc = ''.join(chunks) if chunks else html_text

        vid_regexes = [
            r'\{"category":\{[^}]+\},"channel":\{(?P<chan>[^}]+)\},"duration":(?P<dur>\d+),"end_time":"[^"]+","featured_details":\{[^}]*\},"id":"' + re.escape(vod_id) + r'".*?"start_time":"(?P<start_time>[^"]+)".*?"thumbnail":\{"src":"(?P<thumb_src>[^"]+)"[^}]*\}.*?"title":"(?P<title>[^"]+)"',
            r'"id":"' + re.escape(vod_id) + r'".*?"start_time":"(?P<start_time>[^"]+)".*?"thumbnail":\{"src":"(?P<thumb_src>[^"]+)"[^}]*\}.*?"title":"(?P<title>[^"]+)"',
            r'"start_time":"(?P<start_time>[^"]+)".*?"thumbnail":\{"src":"(?P<thumb_src>[^"]+)"[^}]*\}.*?"title":"(?P<title>[^"]+)".*?"id":"' + re.escape(vod_id) + r'"',
        ]

        for rgx in vid_regexes:
            m = re.search(rgx, full_rsc)
            if m:
                d = m.groupdict()
                thumb_m = re.search(r'video_thumbnails/([^/]+)/([^/]+)', d['thumb_src'])
                if thumb_m:
                    ck, bid = thumb_m.groups()
                    dt = datetime.fromisoformat(d['start_time'].replace('Z', '+00:00'))
                    m3u8 = f"https://stream.kick.com/3c81249a5ce0/ivs/v1/196233775518/{ck}/{dt.year}/{dt.month}/{dt.day}/{dt.hour}/{dt.minute}/{bid}/media/hls/master.m3u8"
                    author_m = re.search(r'"username":"([^"]+)"', d.get('chan', ''))
                    author = author_m.group(1) if author_m else None
                    return m3u8, author, d.get('title')

        # Fallback search for any video thumbnail & start time in full_rsc
        thumb_gen = re.search(r'video_thumbnails(?:/|\\/)(?P<channel_key>[a-zA-Z0-9_-]+)(?:/|\\/)(?P<broadcast_id>[a-zA-Z0-9_-]+)', full_rsc)
        start_gen = re.search(r'start_time(?:\"|\\\"|:|\s)+?(?P<start_time>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z)', full_rsc)
        title_gen = re.search(r'<title>(?P<title>[^<]+)</title>', html_text)
        if thumb_gen and start_gen:
            ck = thumb_gen.group('channel_key')
            bid = thumb_gen.group('broadcast_id')
            dt = datetime.fromisoformat(start_gen.group('start_time').replace('Z', '+00:00'))
            m3u8 = f"https://stream.kick.com/3c81249a5ce0/ivs/v1/196233775518/{ck}/{dt.year}/{dt.month}/{dt.day}/{dt.hour}/{dt.minute}/{bid}/media/hls/master.m3u8"
            title = title_gen.group('title') if title_gen else None
            return m3u8, None, title

        return None, None, None

    def _get_streams_vod(self):
        self.id = self.match["vod"]
        channel = self.match.groupdict().get("channel")

        # Attempt 1: Try legacy v1 API endpoint (works for numeric IDs and legacy slugs)
        try:
            hls_url, self.author, self.title = self._query_api(
                self._URL_API_VOD.format(vod=self.id),
                schema=validate.Schema(
                    {
                        "source": validate.url(path=validate.endswith(".m3u8")),
                        "livestream": {
                            "session_title": str,
                            "channel": {
                                "user": {
                                    "username": str,
                                },
                            },
                        },
                    },
                    validate.union_get(
                        "source",
                        ("livestream", "channel", "user", "username"),
                        ("livestream", "session_title"),
                    ),
                ),
            )
            return HLSStream.parse_variant_playlist(self.session, hls_url, start_offset=self.time_offset)
        except Exception:
            log.debug("Legacy VOD API failed, attempting channel/HTML extraction")

        # Attempt 2: If channel is available, check channel videos endpoint
        if channel:
            try:
                channel_videos = self._query_api(
                    f"https://kick.com/api/v2/channels/{channel}/videos",
                    schema=validate.Schema(
                        [
                            {
                                "id": int,
                                "slug": str,
                                "session_title": str,
                                "source": validate.url(path=validate.endswith(".m3u8")),
                            }
                        ]
                    ),
                )
                for v in channel_videos:
                    if str(v["id"]) == self.id or v["slug"] == self.id or self.id in v["slug"]:
                        self.author = channel
                        self.title = v["session_title"]
                        return HLSStream.parse_variant_playlist(self.session, v["source"], start_offset=self.time_offset)
            except Exception as e:
                log.debug(f"Channel videos query failed: {e}")

        # Attempt 3: Fetch the web page HTML and extract metadata from React Server Components (Next.js)
        res = self.session.http.get(self.url, headers=self._get_api_headers(), raise_for_status=False)
        if res.status_code == 403 and self._get_cookies_from_webbrowser():
            res = self.session.http.get(self.url, headers=self._get_api_headers(), raise_for_status=False)

        if res.status_code == 200:
            hls_url, author, title = self._extract_vod_from_html(res.text, self.id)
            if hls_url:
                if author:
                    self.author = author
                elif channel:
                    self.author = channel
                if title:
                    self.title = title
                return HLSStream.parse_variant_playlist(self.session, hls_url, start_offset=self.time_offset)

        raise PluginError(f"Could not find stream for Kick VOD {self.id}")

    def _get_streams_clip(self):
        self.id = self.match["clip"]
        self.author = self.match["channel"]

        hls_url, self.category, self.title = self._query_api(
            self._URL_API_CLIP.format(clip=self.id),
            schema=validate.Schema(
                {
                    "clip": {
                        "clip_url": validate.url(path=validate.endswith(".m3u8")),
                        "category": {"name": str},
                        "title": str,
                    },
                },
                validate.get("clip"),
                validate.union_get(
                    "clip_url",
                    ("category", "name"),
                    "title",
                ),
            ),
        )

        return {"clip": HLSStream(self.session, hls_url)}

    def _get_streams(self):
        if self.matches["live"]:
            return self._get_streams_live()
        if self.matches["vod"]:
            return self._get_streams_vod()
        if self.matches["clip"]:
            return self._get_streams_clip()


__plugin__ = Kick
