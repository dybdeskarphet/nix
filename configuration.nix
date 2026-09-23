{ inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    min-free = 5 * 1024 * 1024 * 1024;
    http-connections = 50;
    connect-timeout = 5;
    stalled-download-timeout = 10;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  imports = [
    ./modules/core/system.nix
  ];

  system.stateVersion = "25.11";
}
