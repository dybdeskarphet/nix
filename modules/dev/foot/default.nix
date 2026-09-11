{ pkgs, ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;

    settings = {
      main = {
        term = "foot";
        font = "monospace:size=10";
        font-size-adjustment = 1.0;
        box-drawings-uses-font-glyphs = "no";
        pad = "0x0";
        bold-text-in-bright = "no";
        word-delimiters = " ,│`|:\\\"'()[]{}<>";
        include = "~/.config/foot/colors.ini";
      };

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
    };
  };

  xdg.configFile."matugen/templates/foot.ini".source = ./colors.temp.ini;
}
