{ pkgs, lib, ... }:
{
  services.hypridle = {
    enable = true;

    settings = {
      listener = [
        {
          timeout = 300;
          on-timeout = "${lib.getExe pkgs.hyprlock}";
          on-resume = "${lib.getExe pkgs.niri} msg action power-on-monitors";
        }
        {
          timeout = 900;
          on-timeout = "${lib.getExe pkgs.niri} msg action power-off-monitors";
          on-resume = "${lib.getExe pkgs.niri} msg action power-on-monitors";
        }
        {
          timeout = 960;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
