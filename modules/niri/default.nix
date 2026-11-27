{ ... }:
{
  # NixOS {{{
  nixos.niri =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        xwayland-satellite
      ];

      programs.niri = {
        enable = true;
        useNautilus = false;
      };
    };
  # }}}

  # Home Manager {{{
  home.niri =
    {
      pkgs,
      lib,
      config,
      colors,
      colorHelpers,
      ...
    }:
    {
      home.packages = with pkgs; [
        playerctl
        libnotify
        nirius
      ];

      systemd.user.services.niriusd = {
        Unit = {
          Description = "Nirius daemon for niri";
          ConditionEnvironment = "WAYLAND_DISPLAY";
          After = [ config.wayland.systemd.target ];
          PartOf = [ config.wayland.systemd.target ];
        };
        Install = {
          WantedBy = [ config.wayland.systemd.target ];
        };
        Service = {
          ExecStart = lib.getExe' pkgs.nirius "niriusd";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };

      xdg.configFile = {
        "niri/config.kdl".text = ''
          include "~/.config/niri/src/input.kdl"
          include "~/.config/niri/src/internal.kdl"
          include "~/.config/niri/src/keybindings.kdl"
          include "~/.config/niri/src/rules.kdl"
          include "~/.config/niri/src/visual.kdl"
          include "~/.config/niri/extra.kdl"

          layout {
              border {
                  active-color "${colors.primary}"
                  inactive-color "${colors.on_secondary_fixed_variant}"
                  urgent-color "${colors.error_container}"
              }
              insert-hint {
                  color "#${colorHelpers.stripHash colors.primary}aa"
              }
          }

          recent-windows {
              highlight {
                  active-color "${colors.primary}"
                  urgent-color "${colors.error_container}"
              }
          }
        '';

        "niri/src" = {
          source = ./src;
          recursive = true;
        };

        "niri/extra.kdl".text = lib.mkDefault "";

        "elephant/menus/niri.toml".source = (pkgs.formats.toml { }).generate "niri.toml" {
          name = "niri";
          name_pretty = "Niri";
          icon = "";
          fixed_order = true;
          entries = [
            {
              text = "niri: immersive";
              icon = "";
              actions.activate = "niri msg action load-config-file --path ~/.config/niri/src/modes/immersive.kdl && pkill -SIGUSR1 waybar";
            }
            {
              text = "niri: normal";
              icon = "";
              actions.activate = "niri msg action load-config-file --path ~/.config/niri/config.kdl && pkill -SIGUSR1 waybar";
            }
          ];
        };
      };
    };
  # }}}
}

# -- vim: fdm=marker fdl=0
