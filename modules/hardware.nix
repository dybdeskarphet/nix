{ ... }:
{
  nixos.hardware =
    { ... }:
    {
      hardware = {
        graphics.enable = true;
        enableRedistributableFirmware = true;
      };

      services.fstrim.enable = true;
      services.smartd = {
        enable = true;
        notifications = {
          systembus-notify.enable = true;
          wall.enable = true;
        };
      };

      services.logind.settings.Login = {
        HandlePowerKey = "poweroff";
        HandlePowerKeyLongPress = "halt";
      };

      security.rtkit.enable = true;
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        socketActivation = false;
        pulse.enable = true;
        wireplumber.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
      systemd.user.services.pipewire.wantedBy = [ "default.target" ];
      systemd.user.services.pipewire-pulse.wantedBy = [ "default.target" ];
    };
}
