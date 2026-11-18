{ ... }:
{
  hardware.openrazer = {
    enable = true;
    users = [ "skarphet" ];

    syncEffectsEnabled = true;
    verboseLogging = false;

    batteryNotifier = {
      enable = true;
      frequency = 3600;
      percentage = 33;
    };
  };
}
