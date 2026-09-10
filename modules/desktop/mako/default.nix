{ pkgs, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      font = "proportional_font 11";
      width = 300;
      height = 160;
      padding = 11;
      border-size = 2;
      border-radius = 7;
      anchor = "top-right";
      outer-margin = 7;
      margin = "0,0,8,0";

      markup = true;
      format = ''<b>%s</b> <span rise="2pt" size="small" fgalpha="60%" text_transform="uppercase">| %a</span>\n%b'';
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
      on-button-middle = "exec ${pkgs.mako}/bin/makoctl menu -n \"$id\" -- ${pkgs.rofi-wayland}/bin/rofi -dmenu -p 'Select action:'";

      "app-name=niri" = {
        invisible = 1;
      };

      "app-name=chromium" = {
        default-timeout = 3000;
      };

      "urgency=critical" = {
        default-timeout = 0;
        ignore-timeout = 1;
      };

      "mode=dnd" = {
        invisible = 1;
      };
    };
    extraConfig = ''
      include=~/.config/mako/colors
    '';
  };

  xdg.configFile."matugen/templates/mako".source = ./colors.temp;
}
