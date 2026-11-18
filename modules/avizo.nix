{ ... }:
{
  flake.modules.homeManager.desktop =
    { lib, colors, ... }:
    let
      # Color Helpers {{{
      hexToRgba =
        alpha: hex:
        let
          clean = lib.removePrefix "#" hex;
          r = lib.fromHexString (builtins.substring 0 2 clean);
          g = lib.fromHexString (builtins.substring 2 2 clean);
          b = lib.fromHexString (builtins.substring 4 2 clean);
        in
        "rgba(${toString r}, ${toString g}, ${toString b}, ${toString alpha})";
      # }}}
    in
    {
      # Avizo Service & Settings {{{
      services.avizo = {
        enable = true;

        settings.default = {
          time = 1.5;
          y-offset = 0.5;
          x-offset = 0.5;
          border-radius = 10;
          border-width = 0;
          fade-in = 0.2;
          fade-out = 0.3;

          background = hexToRgba 0.8 colors.primary;
          border-color = hexToRgba 0.8 colors.outline;
          bar-fg-color = hexToRgba 0.8 colors.background;
        };
      };
      # }}}
    };
}

# -- vim: fdm=marker fdl=0
