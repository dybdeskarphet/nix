{ ... }:
{
  home.mako =
    { pkgs, colors, ... }:
    {
      services.mako = {
        enable = true;

        settings = {
          # Global Settings {{{
          font = "proportional_font 11";
          width = 300;
          height = 160;
          padding = 11;
          border-size = 2;
          border-radius = 7;
          anchor = "top-right";
          outer-margin = 7;
          margin = "0,0,8,0";
          default-timeout = 5000;

          background-color = "${colors.surface_container}99";
          text-color = colors.on_surface;
          border-color = "${colors.on_secondary}b3";
          progress-color = "over ${colors.on_secondary_container}";

          markup = true;
          format = "<b>%s</b> <span rise='2pt' size='small' fgalpha='60%%' text_transform='uppercase'>| %a</span>\\n%b";
          text-alignment = "left";

          icons = true;
          max-icon-size = 32;
          icon-location = "left";
          icon-border-radius = 7;
          icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";

          max-visible = 20;
          max-history = 20;
          history = 1;
          sort = "-time";
          group-by = "app-name,summary";

          on-button-left = "invoke-default-action";
          on-button-right = "dismiss-all";
          on-button-middle = "exec ${pkgs.mako}/bin/makoctl menu -n \"$id\" -- ${pkgs.walker}/bin/walker --dmenu -p 'Select action:'";
          # }}}

          # Criteria Rules {{{
          "app-name=niri" = {
            invisible = 1;
          };

          "app-name=elecwhat" = {
            max-icon-size = 64;
            default-timeout = 8000;
          };

          "app-name=Screenshot" = {
            max-icon-size = 128;
            default-timeout = 3000;
          };

          "urgency=critical" = {
            default-timeout = 0;
            ignore-timeout = 1;
            background-color = "${colors.on_error}b3";
            text-color = colors.on_error_container;
            border-color = "${colors.error_container}b3";
          };

          "mode=dnd" = {
            invisible = 1;
          };
          # }}}
        };
      };
    };
}

# -- vim: fdm=marker fdl=0
