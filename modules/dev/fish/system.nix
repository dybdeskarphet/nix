{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dmidecode
    gnugrep
    gnused
  ];

  programs.nix-index-database.comma.enable = true;
}
