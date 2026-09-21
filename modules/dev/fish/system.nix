{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dmidecode
    gnugrep
    gnused
  ];
}
