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
      };

      colors-dark = {
        # Monokai Pro Spectrum (from min.nvim)
        foreground = "f4f4f4";
        background = "191919";

        regular0 = "222222";
        regular1 = "fc618d";
        regular2 = "7bd88f";
        regular3 = "fce566";
        regular4 = "6fa5eb";
        regular5 = "948ae3";
        regular6 = "5ad4e6";
        regular7 = "d4d4d4";

        bright0 = "676767";
        bright1 = "ff779e";
        bright2 = "8ce19e";
        bright3 = "ffeb7c";
        bright4 = "82b2f1";
        bright5 = "a59cea";
        bright6 = "6ddced";
        bright7 = "f4f4f4";

        alpha = 0.85;
        alpha-mode = "matching";

        jump-labels = "191919 fce566";
        urls = "5ad4e6";
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
}
