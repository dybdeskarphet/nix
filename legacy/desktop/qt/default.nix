{ config, pkgs, ... }:
let
  iniFormat = pkgs.formats.ini { };

  qtSettings = {
    Appearance = {
      color_scheme_path = "${config.home.homeDirectory}/.config/qt6ct/colors/matugen.conf";
      custom_palette = true;
      icon_theme = config.gtk.iconTheme.name;
      standard_dialogs = "gtk3";
      style = "Fusion";
    };
    Fonts = {
      fixed = "Noto Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      general = "Noto Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
    };
    Interface = {
      activate_item_on_single_click = 1;
    };
    Troubleshooting = {
      force_raster_widgets = 1;
    };
  };

  qt5Settings = qtSettings // {
    Appearance = qtSettings.Appearance // {
      color_scheme_path = "${config.home.homeDirectory}/.config/qt5ct/colors/matugen.conf";
    };
  };
in
{
  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
    style.name = "Fusion";
  };

  home.packages = with pkgs; [
    libsForQt5.qt5ct
    kdePackages.qt6ct
    noto-fonts
  ];

  xdg.configFile."qt5ct/qt5ct.conf".source = iniFormat.generate "qt5ct.conf" qt5Settings;
  xdg.configFile."qt6ct/qt6ct.conf".source = iniFormat.generate "qt6ct.conf" qtSettings;
  xdg.configFile."matugen/templates/qt-colors.conf".source = ./colors.temp.conf;
}
