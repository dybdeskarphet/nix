{ ... }:
{
  home.gui =
    { pkgs, ... }:
    {
      xdg.configFile."elephant/menus/quickmenu.toml".source =
        (pkgs.formats.toml { }).generate "quickmenu.toml" {
        name = "quickmenu";
        name_pretty = "Quick Settings";
        icon = "";
        fixed_order = true;
        entries = [
          {
            text = "reload: waybar";
            icon = "󰑓";
            actions.activate = "systemctl --user restart waybar.service";
          }
          {
            text = "reload: mako";
            icon = "󰑓";
            actions.activate = "systemctl --user restart mako.service";
          }
          {
            text = "reload: awww";
            icon = "󰑓";
            actions.activate = "systemctl --user restart awww-backdrop.service awww-bg.service";
          }
          {
            text = "reload: foot server";
            icon = "󰑓";
            actions.activate = "systemctl --user restart foot.service";
          }
        ];
      };
    };
}
