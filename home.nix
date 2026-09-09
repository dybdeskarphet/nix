{ pkgs, ... }:
{
  home.username = "skarphet";
  home.stateVersion = "25.11";
  home.homeDirectory = "/home/skarphet";
  home.packages = with pkgs; [
    fzf
    lsd
  ];

  imports = [
    ./modules/core/home.nix
  ];
}
