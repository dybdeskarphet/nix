{ ... }:
{
  nixos.bluetooth =
    { lib, config, ... }:
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
            FastConnectable = true;
            ControllerMode = "dual";
          };
          Policy = {
            AutoEnable = true;
          };
        };
      };

      services.blueman.enable = true;

      services.tlp.settings = lib.mkIf config.services.tlp.enable {
        DEVICES_TO_ENABLE_ON_AC = "bluetooth";
        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth";
      };
    };
}
