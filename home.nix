{ pkgs, ... }:
{
  home.username = "skarphet";
  home.stateVersion = "25.11";
  home.homeDirectory = "/home/skarphet";
  home.packages = with pkgs; [
    fzf
  ];

  imports = [
    ./modules/home/fish/fish.nix
    ./modules/home/env.nix
  ];
}
