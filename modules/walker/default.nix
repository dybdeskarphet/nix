{ ... }:
{
  home.walker =
    {
      pkgs,
      colors,
      helpers,
      ...
    }:
    let
      rgba = helpers.colors.hexToRgba;
    in
    {
      home.packages = [ pkgs.netcat-openbsd ];

      services.elephant.enable = true;

      services.walker = {
        enable = true;
        systemd.enable = true;
        enableElephantIntegration = true;

        settings = {
          force_keyboard_focus = true;
          click_to_close = false;
          close_when_open = true;
          selection_wrap = true;
          hide_action_hints = true;
          hide_quick_activation = true;
          ext_background_effect_blur = true;
          blur_corner_radius = 8;

          shell = {
            layer = "overlay";
            anchor_top = false;
            anchor_bottom = false;
            anchor_left = false;
            anchor_right = false;
          };

          providers = {
            default = [
              "desktopapplications"
              "runner"
              "menus"
            ];
            empty = [
              "desktopapplications"
            ];
            ignore_preview = [
              "desktopapplications"
              "runner"
              "menus"
            ];
          };

          placeholders = {
            default = {
              input = "Search...";
              list = "No results";
            };
          };
        };

        theme = {
          name = "custom";
          layout.layout = ./layout.xml;

          style = ''
            * {
              all: unset;
            }

            window,
            .window {
              background: transparent;
              font-family: "proportional_font";
              font-size: 13pt;
              font-weight: 500;
              color: ${colors.on_surface};
            }

            scrollbar {
              opacity: 0;
            }

            .normal-icons {
              -gtk-icon-size: 16px;
            }

            .large-icons {
              -gtk-icon-size: 24px;
            }

            .box-wrapper {
              background-color: ${rgba 0.8 colors.surface_container_low};
              border: 1px solid ${rgba 0.7 colors.outline_variant};
              border-radius: 8px;
            }

            .search-container {
              padding: 15px 18px;
              border-bottom: 1px solid ${rgba 0.4 colors.outline_variant};
            }

            .input {
              caret-color: ${colors.primary};
            }

            .input placeholder {
              color: ${colors.on_surface_variant};
            }

            .input selection {
              background-color: ${rgba 0.25 colors.primary};
            }

            .placeholder,
            .elephant-hint {
              padding: 12px 18px;
              color: ${colors.on_surface_variant};
            }

            .scroll {
              padding: 8px;
            }

            .item-box {
              padding: 10px 12px;
              margin: 1px 0;
              border: 1px solid transparent;
              border-radius: 5px;
            }

            child:selected .item-box,
            row:selected .item-box {
              background-color: ${rgba 0.1 colors.on_surface};
              border: 1px solid ${rgba 0.6 colors.outline_variant};
              color: ${colors.primary};
            }

            .item-subtext {
              font-size: 10pt;
              color: ${colors.on_surface_variant};
            }

            .item-image-text {
              font-size: 15pt;
            }

            .error {
              padding: 9px 18px;
              background-color: ${rgba 0.5 colors.error_container};
              color: ${colors.on_error_container};
            }
          '';
        };
      };
    };
}
