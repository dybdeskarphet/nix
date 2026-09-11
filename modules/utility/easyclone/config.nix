{ pkgs, lib, ... }:
let
  tomlFormat = pkgs.formats.toml { };
  easycloneSettings = {
    rclone = {
      args = [
        "--update"
        "--verbose"
        "--transfers 4"
        "--checkers 16"
        "--contimeout 60s"
        "--timeout 300s"
        "--tpslimit 4"
        "--min-age 15s"
        "--drive-chunk-size 32M"
        "--retries 3"
        "--low-level-retries 10"
        "--stats 30s"
        "--exclude-from /home/skarphet/.config/easyclone/excludes.txt"
      ];
      concurrent_limit = 5;
    };

    backup = {
      remote_name = "GDrive-Compress";
      root_dir = "Backup";
      verbose_log = true;
      sync_paths = [ ];
      copy_paths = [ ];
    };

    daemon = {
      interval = 1;
      countdown = true;
    };
  };
in
{
  xdg.configFile."easyclone/config.toml".source =
    tomlFormat.generate "easyclone-config.toml" easycloneSettings;

}
