{ ... }:
{
  nixos.openrazer =
    { username, ... }:
    {
      hardware.openrazer = {
        enable = true;
        users = [ username ];
        batteryNotifier.frequency = 3600;
      };
    };

  home.openrazer =
    {
      pkgs,
      colors,
      colorHelpers,
      ...
    }:
    let
      rgb = colorHelpers.hexToRgb colors.source_color;
      openrazerColor = pkgs.writers.writePython3 "openrazer-color" {
        libraries = [ pkgs.python3Packages.openrazer ];
        doCheck = false;
      } ''
        import colorsys
        import openrazer.client

        r, g, b = ${toString rgb.r}, ${toString rgb.g}, ${toString rgb.b}
        h, s, _ = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
        if s > 0:
            r, g, b = (round(c * 255) for c in colorsys.hsv_to_rgb(h, min(0.65, s + 0.40), 0.75))

        for dev in openrazer.client.DeviceManager().devices:
            if dev.has("lighting_ripple"):
                dev.fx.ripple(r, g, b)
      '';
    in
    {
      systemd.user.services.openrazer-color = {
        Unit = {
          Description = "Apply theme color to OpenRazer devices";
          After = [ "openrazer-daemon.service" ];
          Requires = [ "openrazer-daemon.service" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${openrazerColor}";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      xdg.configFile."niri/extra.kdl".text = ''
        binds {
            XF86Macro27 { spawn "notify-send" "-r" "134897" "-a" "Razer" "-i" "keyboard" "brightness increased"; }
            XF86Macro28 { spawn "notify-send" "-r" "134897" "-a" "Razer" "-i" "keyboard" "brightness decreased"; }
        }
      '';
    };
}
