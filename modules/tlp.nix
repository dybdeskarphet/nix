{ ... }:
{
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      AMDGPU_ABM_LEVEL_ON_BAT = 2;
      WIFI_PWR_ON_BAT = "off";
      SOUND_POWER_SAVE_ON_AC = 1;
      SOUND_POWER_SAVE_ON_BAT = 1;
      RUNTIME_PM_DRIVER_DENYLIST = "";
      USB_DENYLIST = "1532:009c 1532:02a3";
      USB_EXCLUDE_PHONE = 1;
      DEVICES_TO_DISABLE_ON_STARTUP = "nfc wwan";
      DEVICES_TO_ENABLE_ON_STARTUP = "bluetooth wifi";
      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth nfc wifi wwan";
      DEVICES_TO_DISABLE_ON_WIFI_CONNECT = "wwan";
      DEVICES_TO_DISABLE_ON_WWAN_CONNECT = "wifi";
      DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi wwan";
    };
  };
}
