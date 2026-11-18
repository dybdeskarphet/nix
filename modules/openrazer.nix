{ ... }:
{
  nixos.hardware =
    { ... }:
    {
      hardware.openrazer = {
        enable = true;
        users = [ "skarphet" ];

        syncEffectsEnabled = true;
        verboseLogging = false;

        batteryNotifier = {
          enable = true;
          frequency = 3600;
          percentage = 33;
        };
      };
    };

  home.hardware =
    {
      pkgs,
      colors,
      helpers,
      ...
    }:
    let
      rgb = helpers.colors.hexToRgb colors.primary;
      openrazerColor = pkgs.writers.writePython3 "openrazer-color" {
        libraries = with pkgs.python3Packages; [ openrazer ];
        doCheck = false;
      } ''
        import colorsys
        import sys
        import openrazer.client

        r, g, b = ${toString rgb.r}, ${toString rgb.g}, ${toString rgb.b}
        h, l, s = colorsys.rgb_to_hls(r / 255.0, g / 255.0, b / 255.0)
        if s > 0.0:
            s = min(1.0, s + 0.30)
            r, g, b = [round(c * 255) for c in colorsys.hls_to_rgb(h, l, s)]

        dm = openrazer.client.DeviceManager()
        for dev in dm.devices:
            if dev.has("lighting_reactive"):
                try:
                    dev.fx.reactive(r, g, b, 0x01)
                except Exception as e:
                    print(f"Failed to set effect on {dev.name}: {e}", file=sys.stderr)
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
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
