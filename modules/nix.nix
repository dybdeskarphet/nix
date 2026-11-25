{ inputs, ... }:
{
  nixos.base =
    {
      pkgs,
      pkgs-stable,
      config,
      ...
    }:
    {
      imports = [ inputs.nix-index-database.nixosModules.nix-index ];

      # Nix & Packaging {{{
      nixpkgs.config.allowUnfree = true;

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
        min-free = 5 * 1024 * 1024 * 1024;
        http-connections = 50;
        connect-timeout = 5;
        stalled-download-timeout = 10;
        download-buffer-size = 128 * 1024 * 1024;
        allowed-users = [
          "@wheel"
          "skarphet"
        ];
      };

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      nix.optimise = {
        automatic = true;
        dates = [ "weekly" ];
      };

      nix.registry.nixpkgs.flake = inputs.nixpkgs;
      programs.nix-index-database.comma.enable = true;

      programs.nh = {
        enable = true;
        flake = "${config.users.users.skarphet.home}/code/nix";
      };

      nixpkgs.overlays = [
        (final: prev: {
          tabiew = pkgs-stable.tabiew;
        })
        (final: prev: {
          aggregateModules =
            modules:
            (prev.aggregateModules modules).overrideAttrs (old: {
              postBuild =
                builtins.replaceStrings
                  [ "xargs -d'\\n' cat >> modules.cer" ]
                  [ "while read -r cer; do if [ -f \"$cer\" ]; then cat \"$cer\"; fi; done >> modules.cer" ]
                  old.postBuild;
            });
        })
      ];
      # }}}

      # Dynamic Linker & Docs {{{
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          wayland
          glib
          libGL
          libxkbcommon
          fontconfig
          freetype
          dbus
          libx11
          alsa-lib
          libpulseaudio
          libogg
          libvorbis
        ];
      };

      documentation = {
        enable = true;
        man.enable = true;
        dev.enable = true;
      };
      # }}}
    };
}

# -- vim: fdm=marker fdl=0
