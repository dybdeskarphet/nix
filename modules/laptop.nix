{ ... }:
{
  flake.modules.nixos.laptop =
    { ... }:
    {
      # Boot & Kernel {{{
      boot = {
        initrd.kernelModules = [
          "amdgpu"
          "vkms"
        ];
        kernelModules = [
          "vkms"
        ];
        extraModprobeConfig = ''
          # realtek wi-fi stability
          options rtw88_pci disable_aspm=y
          options rtw88_core disable_lps_deep=y
        '';
        kernelParams = [
          "video=1920x1080"
          "acpi_backlight=amdgpu_bl1"
          "btusb.enable_autosuspend=0"
          "rfkill.default_state=1"
        ];
      };
      # }}}

      # Hardware & Power {{{
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
      # }}}
    };
}

# -- vim: fdm=marker fdl=0
