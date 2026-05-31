{ ... }:
{
  home.username = "skarphet";
  home.stateVersion = "25.11";
  home.homeDirectory = "/home/skarphet";
  home.

  imports = [
    ./modules/home/fish/fish.nix
  ];
}
