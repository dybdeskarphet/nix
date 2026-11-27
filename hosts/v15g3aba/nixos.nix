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
      "acpi_backlight=amdgpu_bl1"
      "btusb.enable_autosuspend=0"
      "rfkill.default_state=1"
    ];
  };

  services.tlp.settings = {
    AMDGPU_ABM_LEVEL_ON_BAT = 2;
    USB_DENYLIST = "1532:009c 1532:02a3 0bda:c123";
    STOP_CHARGE_THRESH_BAT0 = 1;
  };
}
