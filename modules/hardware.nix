{ ... }:
{
  # Base Storage, Power & Audio {{{
  nixos.base =
    { ... }:
    {
      services.fwupd.enable = true;
      services.fstrim.enable = true;
      services.smartd = {
        enable = true;
        notifications.wall.enable = true;
      };

      services.logind.settings = {
        Login = {
          HandlePowerKey = "poweroff";
          HandlePowerKeyLongPress = "halt";
          HandleLidSwitch = "suspend";
          HandleLidSwitchExternalPower = "suspend";
        };
      };

      security.rtkit.enable = true;
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        socketActivation = false;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      systemd.user.services.pipewire.wantedBy = [ "default.target" ];
      systemd.user.services.pipewire-pulse.wantedBy = [ "default.target" ];
    };
  # }}}

  # Laptop Hardware & Power {{{
  nixos.hardware =
    { ... }:
    {
      hardware = {
        graphics.enable = true;
        cpu.amd.updateMicrocode = true;
        enableRedistributableFirmware = true;
      };

      services.upower = {
        enable = true;
        percentageLow = 15;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate"; # or "PowerOff" / "Suspend"
      };
    };
  # }}}
}

# -- vim: fdm=marker fdl=0
