{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    ./modules/core.nix
    ./modules/tlp.nix
  ];

  system.stateVersion = "25.11";
}
