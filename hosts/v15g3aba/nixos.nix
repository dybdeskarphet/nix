{ inputs, ... }:
{
  imports = [
    "${inputs.private}/hardware-configuration.nix"
  ];

  networking.hostName = "v15g3aba";

  hardware.cpu.amd.updateMicrocode = true;

  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    extraModprobeConfig = ''
      # realtek wi-fi stability
      options rtw88_pci disable_aspm=y
      options rtw88_core disable_lps_deep=y
    '';
    kernelParams = [
      "video=1920x1080"
      "acpi_backlight=native"
      "btusb.enable_autosuspend=0"
      "rfkill.default_state=1"
    ];
  };

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };

    upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "Hibernate"; # or "PowerOff" / "Suspend"
    };

    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        # cpu
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        # gpu
        AMDGPU_ABM_LEVEL_ON_BAT = 2;

        # wireless
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "off";

        # audio
        SOUND_POWER_SAVE_ON_AC = 1;
        SOUND_POWER_SAVE_ON_BAT = 1;

        # pcie / usb
        RUNTIME_PM_DRIVER_DENYLIST = "";
        USB_EXCLUDE_PHONE = 1;
        USB_DENYLIST = "1532:009c 1532:02a3 0bda:c123";

        # battery
        STOP_CHARGE_THRESH_BAT0 = 1;
      };
    };
  };
}
