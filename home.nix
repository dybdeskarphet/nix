{ pkgs, ... }:
{
  home.username = "skarphet";
  home.stateVersion = "25.11";
  home.homeDirectory = "/home/skarphet";

  imports = [
    ./modules/core/home.nix
  ];
}
