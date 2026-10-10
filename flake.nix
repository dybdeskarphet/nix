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
      hardwarePath = /etc/nixos/hardware-configuration.nix;
      vmHardwarePath = ./hardware-vm.nix;

      localEnvPath = /etc/nixos/env.nix;
      defaultEnvPath = ./env.nix;

      hasLocalEnv = builtins.pathExists localEnvPath;
      hasHardwareConfig = builtins.pathExists hardwarePath;

      defaultEnv = import defaultEnvPath;
      localEnv = if hasLocalEnv then import localEnvPath else { };
      env = nixpkgs.lib.recursiveUpdate defaultEnv localEnv;

      activeHardwarePath = if hasHardwareConfig then hardwarePath else vmHardwarePath;
      activeEnvPath = if hasLocalEnv then localEnvPath else defaultEnvPath;

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
          activeHardwarePath

          {
            warnings = [
              "using ${toString activeHardwarePath} for hardware config"
              "using ${toString activeEnvPath} for env"
            ];
          }

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
