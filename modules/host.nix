{ inputs, config, helpers, ... }:
let
  # Host Paths, Env & Colors {{{
  hardwarePath = /etc/nixos/hardware-configuration.nix;
  vmHardwarePath = ../hardware-vm.nix;

  localEnvPath = /etc/nixos/env.nix;
  defaultEnvPath = ../env.nix;

  hasLocalEnv = builtins.pathExists localEnvPath;
  hasHardwareConfig = builtins.pathExists hardwarePath;

  defaultEnv = import defaultEnvPath;
  localEnv = if hasLocalEnv then import localEnvPath else { };
  env = inputs.nixpkgs.lib.recursiveUpdate defaultEnv localEnv;

  rawColors = builtins.fromJSON (builtins.readFile ../colors.json);
  colors = inputs.nixpkgs.lib.mapAttrs (
    _: v: if builtins.isAttrs v then v.dark.color else v
  ) (rawColors.colors or rawColors);

  activeHardwarePath = if hasHardwareConfig then hardwarePath else vmHardwarePath;
  activeEnvPath = if hasLocalEnv then localEnvPath else defaultEnvPath;

  pkgs-stable = import inputs.nixpkgs-stable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  pkgs-small = import inputs.nixpkgs-small {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  # }}}
in
{
  # Shared Flake Args & Topic Buckets {{{
  _module.args = {
    inherit
      env
      colors
      pkgs-stable
      pkgs-small
      ;
  };

  flake.modules.nixos = {
    base = { };
    desktop = { };
    laptop = { };
  };

  flake.modules.homeManager = {
    base = { };
    desktop = { };
    laptop = { };
  };
  # }}}

  # NixOS Host Configuration {{{
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit
        inputs
        env
        colors
        helpers
        pkgs-stable
        pkgs-small
        ;
    };
    modules = [
      ../legacy/core/system.nix
      activeHardwarePath
      inputs.nix-index-database.nixosModules.nix-index
      config.flake.modules.nixos.base
      config.flake.modules.nixos.desktop
      config.flake.modules.nixos.laptop
      {
        warnings = [
          "using ${toString activeHardwarePath} for hardware config"
          "using ${toString activeEnvPath} for env"
        ];
      }

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit
            inputs
            env
            colors
            helpers
            pkgs-stable
            pkgs-small
            ;
        };
        home-manager.users.skarphet.imports = [
          ../legacy/core/home.nix
          config.flake.modules.homeManager.base
          config.flake.modules.homeManager.desktop
          config.flake.modules.homeManager.laptop
        ];
      }
    ];
  };
  # }}}
}

# -- vim: fdm=marker fdl=0
