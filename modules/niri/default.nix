{ ... }:
{
  # NixOS {{{
  nixos.gui =
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
  home.gui =
    {
      pkgs,
      colors,
      helpers,
      ...
    }:
    {
      home.packages = with pkgs; [
        playerctl
        libnotify
        libqalculate
      ];

      xdg.configFile = {
        "niri/config.kdl".text = ''
          include "~/.config/niri/src/input.kdl"
          include "~/.config/niri/src/internal.kdl"
          include "~/.config/niri/src/keybindings.kdl"
          include "~/.config/niri/src/rules.kdl"
          include "~/.config/niri/src/visual.kdl"
          include "~/.config/niri/src/outputs.kdl"

          layout {
              border {
                  active-color "${colors.primary}"
                  inactive-color "${colors.on_secondary_fixed_variant}"
                  urgent-color "${colors.error_container}"
              }
              insert-hint {
                  color "#${helpers.colors.stripHash colors.primary}aa"
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
      };
    };
  # }}}
}

# -- vim: fdm=marker fdl=0
