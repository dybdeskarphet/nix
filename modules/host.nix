{
  inputs,
  config,
  helpers,
  colors,
  ...
}:
let
  lib = inputs.nixpkgs.lib;

  env = import "${inputs.private}/env.nix";

  pkgs-stable = import inputs.nixpkgs-stable {
    system = env.system;
    config.allowUnfree = true;
  };

  pkgs-small = import inputs.nixpkgs-small {
    system = env.system;
    config.allowUnfree = true;
  };

  sharedArgs = {
    inherit
      inputs
      env
      colors
      helpers
      pkgs-stable
      pkgs-small
      ;
  };

  commonBuckets = [
    "base"
    "cli"
    "gui"
    "services"
    "hardware"
  ];
  emptyBuckets = lib.genAttrs (commonBuckets ++ [ "x86_64" ]) (_: { });
  activeBuckets = commonBuckets ++ lib.optionals (env.system == "x86_64-linux") [ "x86_64" ];
in
{
  _module.args = {
    inherit
      env
      pkgs-stable
      pkgs-small
      ;
  };

  nixos = emptyBuckets;
  home = emptyBuckets;

  flake.nixosConfigurations.nixos = lib.nixosSystem {
    specialArgs = sharedArgs;
    modules = [
      "${inputs.private}/hardware-configuration.nix"
      inputs.home-manager.nixosModules.home-manager
      {
        system.stateVersion = "25.11";
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = sharedArgs;
          users.skarphet = {
            home.stateVersion = "25.11";
            imports = map (b: config.home.${b}) activeBuckets;
          };
        };
      }
    ]
    ++ map (b: config.nixos.${b}) activeBuckets;
  };
}
