{ ... }:
{
  home.streamlink =
    {
      lib,
      config,
      ...
    }:
    {
      programs.streamlink = {
        enable = true;

        settings = {
          player = lib.getExe config.programs.mpv.package;
          default-stream = "best,1080p60,1080p,720p60,720p";

          player-args = "--title='{author} - {title}' --cache=yes --demuxer-max-bytes=100M";

          hls-live-edge = 3;
          hls-segment-threads = 3;
          stream-segment-threads = 3;
          stream-timeout = 30;
          retry-streams = 3;

          twitch-disable-ads = true;
          twitch-low-latency = true;
        };
        plugins = {
          kick = {
            src = ./plugins/kick.py;
            settings = {
              quiet = true;
            };
          };
        };
      };
    };
}
