{ ... }:
{
  home.gtk =
    {
      pkgs,
      colors,
      helpers,
      ...
    }:
    let
      gtkCss = helpers.colors.toCssDefineColors {
        accent_color = colors.primary_fixed_dim;
        accent_fg_color = colors.on_primary_fixed;
        accent_bg_color = colors.primary_fixed_dim;
        window_bg_color = colors.surface_dim;
        window_fg_color = colors.on_surface;
        headerbar_bg_color = colors.surface_dim;
        headerbar_fg_color = colors.on_surface;
        popover_bg_color = colors.surface_dim;
        popover_fg_color = colors.on_surface;
        view_bg_color = colors.surface;
        view_fg_color = colors.on_surface;
        card_bg_color = colors.surface;
        card_fg_color = colors.on_surface;
        sidebar_bg_color = "@window_bg_color";
        sidebar_fg_color = "@window_fg_color";
        sidebar_border_color = "@window_bg_color";
        sidebar_backdrop_color = "@window_bg_color";
      };
    in
    {
      gtk = {
        enable = true;
        colorScheme = "dark";

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

        gtk3.extraCss = gtkCss;

        gtk4 = {
          extraCss = gtkCss;
          theme = null;
        };
      };
    };
}
