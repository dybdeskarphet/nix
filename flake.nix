{
  description = "Dybdeskarphet NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    easyclone = {
      url = "github:dybdeskarphet/easyclone";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    neovim-config = {
      url = "github:dybdeskarphet/neovim-config";
      flake = false;
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
      pkgs-stable = import inputs.nixpkgs-stable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs env pkgs-stable; };
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
            home-manager.extraSpecialArgs = { inherit inputs env pkgs-stable; };
            home-manager.users.skarphet = ./home.nix;
          }
        ];
      };
    };
}
