{ pkgs, ... }:
let
  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      pydbus
      pygobject3
    ]
  );
in
{
  home.packages = with pkgs; [
    brightnessctl
    libnotify
    libcanberra-gtk3
    sound-theme-freedesktop
  ];

  systemd.user.services.battery-monitor = {
    Unit = {
      Description = "Battery & Bluetooth monitor daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      Environment = "PATH=${
        pkgs.lib.makeBinPath (
          with pkgs;
          [
            brightnessctl
            libnotify
            libcanberra-gtk3
          ]
        )
      }:/run/current-system/sw/bin";
      ExecStart = "${pythonEnv}/bin/python3 ${./monitor.py}";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
