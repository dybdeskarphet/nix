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

      services.power-profiles-daemon.enable = false;
      services.tlp = {
        enable = true;
        settings = {
          # cpu
          CPU_SCALING_GOVERNOR_ON_AC = "powersave";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          # graphics
          AMDGPU_ABM_LEVEL_ON_BAT = 2;

          # wireless
          WIFI_PWR_ON_AC = "off";
          WIFI_PWR_ON_BAT = "off";
          DEVICES_TO_ENABLE_ON_AC = "bluetooth";
          DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth";

          # audio
          SOUND_POWER_SAVE_ON_AC = 1;
          SOUND_POWER_SAVE_ON_BAT = 1;

          # pcie / usb
          RUNTIME_PM_DRIVER_DENYLIST = "";
          USB_DENYLIST = "1532:009c 1532:02a3 0bda:c123";
          USB_EXCLUDE_PHONE = 1;

          # battery
          STOP_CHARGE_THRESH_BAT0 = 1;
        };
      };

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
    };
  # }}}
}

# -- vim: fdm=marker fdl=0
