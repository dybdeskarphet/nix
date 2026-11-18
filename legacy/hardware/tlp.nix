{ ... }:
{
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
      DEVICES_TO_DISABLE_ON_STARTUP = "nfc wwan";
      DEVICES_TO_ENABLE_ON_STARTUP = "bluetooth wifi";
      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth nfc wifi wwan";
      DEVICES_TO_DISABLE_ON_WIFI_CONNECT = "wwan";
      DEVICES_TO_DISABLE_ON_WWAN_CONNECT = "wifi";
      DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi wwan";

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
}
