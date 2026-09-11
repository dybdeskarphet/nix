{ pkgs, config, ... }:
{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.configHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    pinentry = pkgs.pinentry-gnome3;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
  };
}
