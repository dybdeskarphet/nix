{ ... }:
{
  home.gui =
    {
      pkgs,
      colors,
      helpers,
      ...
    }:
    let
      s = helpers.colors.stripHash;
    in
    {
      programs.foot = {
        enable = true;
        server.enable = true;

        settings = {
          # Main & Colors {{{
          main = {
            term = "foot";
            font = "monospace:size=10";
            font-size-adjustment = 1.0;
            box-drawings-uses-font-glyphs = "no";
            pad = "0x0";
            bold-text-in-bright = "no";
            word-delimiters = " ,│`|:\\\"'()[]{}<>";
          };

          colors-dark = {
            foreground = s colors.on_surface;
            background = s colors.background;

            regular0 = s colors.surface_container_high;
            regular1 = s colors.red;
            regular2 = s colors.green;
            regular3 = s colors.yellow;
            regular4 = s colors.blue;
            regular5 = s colors.magenta;
            regular6 = s colors.cyan;
            regular7 = s colors.on_surface_variant;

            bright0 = s colors.outline;
            bright1 = s colors.red;
            bright2 = s colors.green;
            bright3 = s colors.yellow;
            bright4 = s colors.blue;
            bright5 = s colors.magenta;
            bright6 = s colors.cyan;
            bright7 = s colors.on_background;

            alpha = 0.85;
            alpha-mode = "matching";

            jump-labels = "${s colors.background} ${s colors.yellow}";
            urls = s colors.cyan;
          };
          # }}}

          # Behavior & Keybindings {{{
          scrollback = {
            lines = 2000;
            multiplier = 3.0;
            indicator-position = "none";
          };

          url = {
            launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
            osc8-underline = "always";
          };

          cursor = {
            style = "block";
            unfocused-style = "hollow";
            blink = "yes";
          };

          tweak = {
            box-drawing-solid-shades = "no";
            grapheme-shaping = "yes";
            dim-amount = 1.0;
          };

          bell = {
            system = "yes";
            urgent = "yes";
            notify = "no";
            visual = "no";
            command = "${pkgs.libpulseaudio}/bin/paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/bell.oga";
          };

          key-bindings = {
            show-urls-copy = "Control+Shift+y";
          };
          # }}}
        };
      };
    };
}

# -- vim: fdm=marker fdl=0
