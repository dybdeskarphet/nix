{
  inputs,
  config,
  helpers,
  ...
}:
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

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

  wallpaperPath = env.wallpaper or null;
  wallpaperSrc =
    if wallpaperPath != null && wallpaperPath != "" then
      builtins.path {
        path = if builtins.isPath wallpaperPath then wallpaperPath else /. + wallpaperPath;
        name = "wallpaper";
      }
    else
      null;

  matugenCfg = pkgs.writeText "matugen-config.toml" ''
    [config]
    fallback_color = "#808080"

    [config.custom_colors]
    red = { color = "#ff0000", blend = true }
    green = { color = "#00ff00", blend = true }
    yellow = { color = "#ffcc00", blend = true }
    blue = { color = "#0000ff", blend = true }
    magenta = { color = "#ff00ff", blend = true }
    cyan = { color = "#00ffff", blend = true }

    [templates]
  '';

  matugenTarget =
    if wallpaperSrc != null then
      ''image "${wallpaperSrc}" --source-color-index 0 --include-image-in-json false''
    else
      ''color hex "#808080"'';

  generatedColorsJson = pkgs.runCommand "colors.json" { } ''
    run_matugen() {
      ${pkgs.lib.getExe pkgs.matugen} \
        ${matugenTarget} \
        -c "${matugenCfg}" \
        -m dark \
        -t "$1" \
        --dry-run \
        -j hex > "$out"
    }

    run_matugen scheme-neutral
    if [ "$(${pkgs.lib.getExe pkgs.jq} -r '.colors.source_color.dark.color' "$out")" = "#808080" ]; then
      run_matugen scheme-fidelity
    fi
  '';

  rawColors = builtins.fromJSON (
    builtins.readFile (
      if wallpaperSrc != null || !(builtins.pathExists ../colors.json) then
        generatedColorsJson
      else
        ../colors.json
    )
  );
  colors = inputs.nixpkgs.lib.mapAttrs (_: v: if builtins.isAttrs v then v.dark.color else v) (
    rawColors.colors or rawColors
  );

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
