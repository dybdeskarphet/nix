{ config, ... }:
{
  programs.yt-dlp = {
    enable = true;

    settings = {
      paths = "home:${config.xdg.userDirs.videos}";
      output = "%(title)s [%(id)s].%(ext)s";

      embed-metadata = true;
      embed-chapters = true;
      embed-thumbnail = true;
      embed-subs = true;
      sub-langs = "all,-live_chat";

      format-sort = "res,codec:av01:vp9.2:vp9:h264";
      merge-output-format = "mkv";

      concurrent-fragments = 4;
      retries = 10;
      fragment-retries = 10;
    };
  };
}
