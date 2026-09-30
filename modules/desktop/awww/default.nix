{
  pkgs,
  lib,
  config,
  ...
}:
let
  awwwDaemon = lib.getExe' pkgs.awww "awww-daemon";
  wallpaperScript = pkgs.writeShellApplication {
    name = "wallpaper";
    runtimeInputs = [
      pkgs.awww
      pkgs.ffmpeg
      pkgs.coreutils
    ];
    text = ''
      image="''${1:-}"

      if [ -z "$image" ] || [ ! -f "$image" ]; then
        echo "Usage: wallpaper <path-to-image>" >&2
        exit 1
      fi

      awww img -n bg --transition-fps 100 --transition-type center "$image"

      cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/awww"
      mkdir -p "$cache_dir"
      blur_img="$cache_dir/backdrop.png"

      ffmpeg -y -i "$image" \
        -vf "scale=iw/4:-1,gblur=sigma=20:steps=2,scale=4*iw:-1" \
        -update 1 -frames:v 1 "$blur_img" -loglevel error

      awww img -n backdrop --transition-fps 100 --transition-type center "$blur_img"
    '';
  };
in
{
  home.packages = [
    pkgs.awww
    wallpaperScript
  ];

  systemd.user.services = {
    awww-bg = {
      Unit = {
        Description = "awww-daemon (main background)";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };
      Install = {
        WantedBy = [ config.wayland.systemd.target ];
      };
      Service = {
        ExecStart = "${awwwDaemon} --namespace bg";
        Restart = "always";
        RestartSec = 5;
      };
    };

    awww-backdrop = {
      Unit = {
        Description = "awww-daemon (niri backdrop)";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };
      Install = {
        WantedBy = [ config.wayland.systemd.target ];
      };
      Service = {
        ExecStart = "${awwwDaemon} --namespace backdrop";
        Restart = "always";
        RestartSec = 5;
      };
    };
  };
}
