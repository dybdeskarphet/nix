{
  pkgs,
  lib,
  config,
  ...
}:
let
  awwwDaemon = lib.getExe' pkgs.awww "awww-daemon";
in
{
  home.packages = [ pkgs.awww ];

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
