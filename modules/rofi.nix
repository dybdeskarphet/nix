{ ... }:
{
  home.gui =
    { pkgs, colors, ... }:
    let
      emptyTheme = pkgs.writeText "empty.rasi" "";
    in
    {
      # Packages & Rofimoji {{{
      home.packages = with pkgs; [
        rofi
        rofimoji
      ];

      xdg.configFile."rofimoji.rc".text = ''
        action clipboard
      '';
      # }}}

      # Spotlight Theme & Config {{{
      xdg.configFile."rofi/config.rasi".text = ''
        configuration {
            matching: "fuzzy";
            sorting-method: "fzf";
            sort: true;
            show-icons: true;
            drun-match-fields: "name,generic,exec,categories,keywords";
        }

        @theme "${emptyTheme}"

        * {
            font: "proportional_font SemiBold 13";
            background-color: transparent;
            text-color: ${colors.on_surface};
            margin: 0px;
            padding: 0px;
            spacing: 0px;
        }

        window {
            location: north;
            anchor: north;
            y-offset: 22%;
            width: 640px;
            border-radius: 12px;
            border: 2px;
            border-color: ${colors.primary}66;
            background-color: ${colors.surface_container}cc;
        }

        mainbox {
            children: [ inputbar, message, listview ];
        }

        inputbar {
            children: [ prompt, entry ];
            spacing: 10px;
            padding: 14px 18px;
            border: 0px 0px 1px 0px;
            border-color: ${colors.outline_variant}80;
        }

        prompt {
            font: "proportional_font Bold 13";
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
            padding: 8px 18px;
            border: 0px 0px 1px 0px;
            border-color: ${colors.outline_variant}80;
            background-color: ${colors.secondary_container}4d;
        }

        textbox {
            text-color: ${colors.primary};
            vertical-align: 0.5;
        }

        listview {
            columns: 1;
            lines: 7;
            fixed-height: false;
            dynamic: true;
            scrollbar: false;
            padding: 8px;
            spacing: 4px;
        }

        element {
            padding: 10px 12px;
            spacing: 12px;
            border: 1px;
            border-color: transparent;
            border-radius: 8px;
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
            background-color: ${colors.primary}2b;
            border: 1px;
            border-color: ${colors.primary}66;
            text-color: ${colors.primary};
        }

        element selected.urgent {
            background-color: ${colors.error_container}80;
            border: 1px;
            border-color: ${colors.error}80;
            text-color: ${colors.on_error_container};
        }

        element-icon {
            size: 1.4em;
            vertical-align: 0.5;
            cursor: inherit;
        }

        element-text {
            text-color: inherit;
            vertical-align: 0.5;
            cursor: inherit;
        }
      '';
      # }}}
    };
}

# -- vim: fdm=marker fdl=0
