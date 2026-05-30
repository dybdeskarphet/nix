{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    ./modules/core.nix
    ./modules/temp.nix
  ];

  system.stateVersion = "24.11";
}
