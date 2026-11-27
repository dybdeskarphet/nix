{ ... }:
{
  home.qt =
    {
      config,
      pkgs,
      lib,
      colors,
      ...
    }:
    let
      iniFormat = pkgs.formats.ini { };

      palette = lib.concatStringsSep ", " [
        colors.on_background
        colors.surface
        "#ffffff"
        "#cacaca"
        "#9f9f9f"
        "#b8b8b8"
        colors.on_background
        "#ffffff"
        colors.on_surface
        colors.background
        colors.background
        colors.shadow
        colors.primary_container
        colors.on_primary_container
        colors.secondary
        colors.primary
        colors.surface
        colors.scrim
        colors.surface
        colors.on_surface
        colors.secondary
      ];

      qtColorScheme = pkgs.writeText "qt-colors.conf" ''
        [ColorScheme]
        active_colors=${palette}
        disabled_colors=${palette}
        inactive_colors=${palette}
      '';

      qtSettings = {
        Appearance = {
          color_scheme_path = "${qtColorScheme}";
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

      xdg.configFile."qt5ct/qt5ct.conf".source = iniFormat.generate "qt5ct.conf" qtSettings;
      xdg.configFile."qt6ct/qt6ct.conf".source = iniFormat.generate "qt6ct.conf" qtSettings;
    };
}
