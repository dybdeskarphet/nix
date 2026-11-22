{ ... }:
{
  home.gui =
    {
      pkgs,
      colors,
      helpers,
      ...
    }:
    let
      emptyTheme = pkgs.writeText "empty.rasi" "";
      rgba = helpers.colors.hexToRgba;
    in
    {
      home.packages = with pkgs; [
        rofi
      ];

      xdg.configFile."rofi/config.rasi".text = ''
        configuration {
            matching: "fuzzy";
            sorting-method: "fzf";
            sort: true;
            show-icons: true;
            click-to-exit: false;
            drun-match-fields: "name,generic,exec,categories,keywords";
        }

        @theme "${emptyTheme}"

        * {
            font: "proportional_font Medium 13";
            background-color: transparent;
            text-color: ${colors.on_surface};
            margin: 0px;
            padding: 0px;
            spacing: 0px;
        }

        window {
            location: north;
            anchor: north;
            y-offset: 20%;
            width: 660px;
            border-radius: 8px;
            border: 1px;
            border-color: ${rgba 0.7 colors.outline_variant};
            background-color: ${rgba 0.8 colors.surface_container_low};
        }

        mainbox {
            children: [ inputbar, message, listview ];
        }

        inputbar {
            children: [ prompt, entry ];
            spacing: 12px;
            padding: 15px 18px;
            border: 0px 0px 1px 0px;
            border-color: ${rgba 0.4 colors.outline_variant};
        }

        prompt {
            font: "proportional_font SemiBold 13";
            text-color: ${colors.primary};
            vertical-align: 0.5;
        }

        entry {
            placeholder: "Search...";
            placeholder-color: ${colors.on_surface_variant};
            text-color: ${colors.on_surface};
            cursor: text;
            vertical-align: 0.5;
        }

        message {
            padding: 9px 18px;
            border: 0px 0px 1px 0px;
            border-color: ${rgba 0.4 colors.outline_variant};
            background-color: ${rgba 0.4 colors.surface_container};
        }

        textbox {
            text-color: ${colors.on_surface_variant};
            vertical-align: 0.5;
        }

        listview {
            columns: 1;
            lines: 8;
            fixed-height: false;
            dynamic: true;
            scrollbar: false;
            padding: 8px;
            spacing: 3px;
        }

        element {
            padding: 10px 12px;
            spacing: 12px;
            border: 1px;
            border-color: transparent;
            border-radius: 5px;
            background-color: transparent;
            text-color: ${colors.on_surface};
            cursor: pointer;
        }

        element normal.normal,
        element alternate.normal {
            background-color: transparent;
            text-color: ${colors.on_surface};
        }

        element normal.active,
        element alternate.active {
            background-color: transparent;
            text-color: ${colors.tertiary};
        }

        element normal.urgent,
        element alternate.urgent {
            background-color: transparent;
            text-color: ${colors.error};
        }

        element selected.normal,
        element selected.active {
            background-color: ${rgba 0.1 colors.on_surface};
            border: 1px;
            border-color: ${rgba 0.6 colors.outline_variant};
            text-color: ${colors.primary};
        }

        element selected.urgent {
            background-color: ${rgba 0.5 colors.error_container};
            border: 1px;
            border-color: ${rgba 0.4 colors.error};
            text-color: ${colors.on_error_container};
        }

        element-icon {
            size: 1.45em;
            vertical-align: 0.5;
            cursor: inherit;
        }

        element-text {
            text-color: inherit;
            vertical-align: 0.5;
            cursor: inherit;
        }
      '';
    };
}
