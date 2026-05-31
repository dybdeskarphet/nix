{ ... }:
{
  home.username = "skarphet";
  home.stateVersion = "25.11";
  home.homeDirectory = "/home/skarphet";

  imports = [
    ./modules/home/fish/fish.nix
    ./modules/home/env.nix
  ];
}
