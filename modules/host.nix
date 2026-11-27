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

  nixosMods = config.flake.modules.nixos or { };
  homeMods = config.flake.modules.homeManager or { };

  mkHost =
    {
      features,
      nixosModules ? [ ],
      homeModules ? [ ],
    }:
    lib.nixosSystem {
      specialArgs = sharedArgs;
      modules = [
        inputs.home-manager.nixosModules.home-manager
        {
          system.stateVersion = "25.11";
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = sharedArgs;
            users.skarphet = {
              home.stateVersion = "25.11";
              imports = map (f: homeMods.${f} or { }) features ++ homeModules;
            };
          };
        }
      ]
      ++ map (f: nixosMods.${f} or { }) features
      ++ nixosModules;
    };
in
{
  _module.args = {
    inherit
      env
      pkgs-stable
      pkgs-small
      ;
  };

  flake.nixosConfigurations.v15g3aba = mkHost (import ../hosts/v15g3aba);
}
