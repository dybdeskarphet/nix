{
  inputs,
  config,
  helpers,
  colors,
  ...
}:
let
  # Host Paths & Env {{{
  defaultEnv = import ../env.nix;
  localEnv = import "${inputs.private}/env.nix";
  env = inputs.nixpkgs.lib.recursiveUpdate defaultEnv localEnv;

  activeHardwarePath = "${inputs.private}/hardware-configuration.nix";

  pkgs-stable = import inputs.nixpkgs-stable {
    system = env.system;
    config.allowUnfree = true;
  };

  pkgs-small = import inputs.nixpkgs-small {
    system = env.system;
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
    x86_64 = { };
  };

  home = {
    base = { };
    cli = { };
    gui = { };
    services = { };
    hardware = { };
    x86_64 = { };
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
      inputs.sops-nix.nixosModules.sops
      config.nixos.base
      config.nixos.cli
      config.nixos.gui
      config.nixos.services
      config.nixos.hardware
      (if env.system == "x86_64-linux" then config.nixos.x86_64 else { })
      {
        system.stateVersion = "25.11";
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
            (if env.system == "x86_64-linux" then config.home.x86_64 else { })
          ];
        };
      }
    ];
  };
  # }}}
}

# -- vim: fdm=marker fdl=0
