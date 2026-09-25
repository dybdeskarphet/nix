{
  description = "Dybdeskarphet NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    easyclone = {
      url = "github:dybdeskarphet/easyclone";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      defaultEnv = import ./env.nix;
      localEnv = if builtins.pathExists /etc/nixos/env.nix then import /etc/nixos/env.nix else { };
      env = nixpkgs.lib.recursiveUpdate defaultEnv localEnv;
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs env; };
        modules = [
          ./configuration.nix
          (
            if builtins.pathExists /etc/nixos/hardware-configuration.nix then
              builtins.trace ">> EVALUATING: hardware-configuration.nix" /etc/nixos/hardware-configuration.nix
            else
              builtins.trace ">> EVALUATING: hardware-vm.nix" ./hardware-vm.nix
          )
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs env; };
            home-manager.users.skarphet = ./home.nix;
          }
        ];
      };
    };
}
