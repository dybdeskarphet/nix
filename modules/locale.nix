{ ... }:
{
  nixos.locale =
    { lib, ... }:
    {
      i18n.supportedLocales = [
        "C.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
        "tr_TR.UTF-8/UTF-8"
      ];
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "tr_TR.UTF-8";
        LC_IDENTIFICATION = "tr_TR.UTF-8";
        LC_MEASUREMENT = "tr_TR.UTF-8";
        LC_MONETARY = "tr_TR.UTF-8";
        LC_NAME = "tr_TR.UTF-8";
        LC_NUMERIC = "tr_TR.UTF-8";
        LC_PAPER = "tr_TR.UTF-8";
        LC_TELEPHONE = "tr_TR.UTF-8";
        LC_TIME = "tr_TR.UTF-8";
      };

      time.timeZone = "Europe/Istanbul";
      console.keyMap = "trq";
      services.timesyncd.enable = lib.mkDefault true;
    };
}
