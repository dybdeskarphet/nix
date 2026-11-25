{
  inputs,
  config,
  helpers,
  colors,
  ...
}:
let
  # Host Paths & Env {{{
  localEnvPath = /etc/nixos/env.nix;
  defaultEnvPath = ../env.nix;
  hasLocalEnv = builtins.pathExists localEnvPath;

  defaultEnv = import defaultEnvPath;
  localEnv = if hasLocalEnv then import localEnvPath else { };
  env = inputs.nixpkgs.lib.recursiveUpdate defaultEnv localEnv;

  activeHardwarePath = /etc/nixos/hardware-configuration.nix;
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
      pkgs-stable
      pkgs-small
      ;
  };

  nixos = {
    base = { };
    cli = { };
    gui = { };
    services = { };
    hardware = { };
  };

  home = {
    base = { };
    cli = { };
    gui = { };
    services = { };
    hardware = { };
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
      activeHardwarePath
      inputs.nix-index-database.nixosModules.nix-index
      config.nixos.base
      config.nixos.cli
      config.nixos.gui
      config.nixos.services
      config.nixos.hardware
      {
        system.stateVersion = "25.11";
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
        home-manager.users.skarphet = {
          home.stateVersion = "25.11";
          imports = [
            config.home.base
            config.home.cli
            config.home.gui
            config.home.services
            config.home.hardware
          ];
        };
      }
    ];
  };
  # }}}
}

# -- vim: fdm=marker fdl=0
