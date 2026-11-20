{ ... }:
{
  nixos.hardware =
    { ... }:
    {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };

  home.hardware =
    { ... }:
    {
      xdg.configFile."OpenTabletDriver/Presets".source = ./presets;
    };
}
