{ ... }:
{
  nixos.opentabletdriver =
    { ... }:
    {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };

  home.opentabletdriver =
    { pkgs, ... }:
    {
      xdg.configFile."OpenTabletDriver/Presets".source = ./presets;

      xdg.configFile."elephant/menus/tablet.toml".source =
        (pkgs.formats.toml { }).generate "tablet.toml" {
        name = "tablet";
        name_pretty = "Tablet";
        icon = "󰓶";
        fixed_order = true;
        entries = [
          {
            text = "tablet: artist mode";
            icon = "󰓶";
            actions.activate = "otd applypreset artist_mode";
          }
          {
            text = "tablet: absolute mode";
            icon = "󰓶";
            actions.activate = "otd applypreset absolute_mode";
          }
          {
            text = "tablet: restart otd";
            icon = "󰓶";
            actions.activate = "systemctl --user restart opentabletdriver.service";
          }
        ];
      };
    };
}
