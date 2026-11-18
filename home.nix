{ pkgs, ... }:
{
  home.username = "skarphet";
  home.stateVersion = "25.11";
  home.homeDirectory = "/home/skarphet";

  imports = [
    ./legacy/core/home.nix
  ];
}
