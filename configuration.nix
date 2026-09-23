{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings = {
    auto-optimise-store = true;
    min-free = 5 * 1024 * 1024 * 1024;
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  imports = [
    ./modules/core/system.nix
  ];

  system.stateVersion = "25.11";
}
