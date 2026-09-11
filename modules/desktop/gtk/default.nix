{ config, pkgs, ... }:
{
  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    font = {
      name = "Adwaita Sans";
      size = 11;
      package = pkgs.adwaita-fonts;
    };

    gtk3 = {
      extraCss = "@import 'colors.css';";
    };

    gtk4 = {
      extraCss = "@import 'colors.css';";
      theme = null;
    };
  };

  xdg.configFile."matugen/templates/gtk-colors.css".source = ./gtk-colors.temp.css;
}
