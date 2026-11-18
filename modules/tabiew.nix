{ ... }:
{
  home.cli =
    {
      pkgs,
      lib,
      colors,
      ...
    }:
    let
      toml = pkgs.formats.toml { };
      style = fg: bg: {
        inherit fg bg;
        add_modifier = "";
        sub_modifier = "";
      };
      tabiew = pkgs.symlinkJoin {
        name = "tabiew-wrapped";
        paths = [
          (pkgs.writeShellScriptBin "tw" ''
            for arg in "$@"; do
              case "$arg" in
                --theme|--theme=*) exec ${lib.getExe' pkgs.tabiew "tw"} "$@" ;;
              esac
            done
            exec ${lib.getExe' pkgs.tabiew "tw"} --theme config "$@"
          '')
          pkgs.tabiew
        ];
      };
    in
    {
      home.packages = [
        tabiew
      ];

      xdg.configFile."tabiew/theme.toml".source = toml.generate "tabiew-theme.toml" {
        table_header = style colors.primary colors.surface_container_high;
        table_headers = [
          (style colors.primary colors.surface_container_low)
          (style colors.secondary colors.surface_container_low)
          (style colors.tertiary colors.surface_container_low)
        ];
        rows = [
          (style colors.on_surface colors.surface_container_lowest)
          (style colors.on_surface colors.surface_container_low)
        ];
        row_highlight = style colors.on_primary_container colors.primary_container;
        table_tags = [
          (style colors.on_secondary_container colors.secondary_container)
          (style colors.on_tertiary_container colors.tertiary_container)
        ];
        block = style colors.outline colors.surface;
        block_tag = style colors.on_primary_fixed colors.primary_fixed;
        text = style colors.on_surface colors.surface;
        text_highlighted = style colors.primary colors.surface_container;
        subtext = style colors.on_surface_variant colors.surface;
        error = style colors.on_error colors.error;
        gutter = style colors.surface_variant colors.surface;
        chart = [
          (style colors.primary colors.surface)
          (style colors.secondary colors.surface)
          (style colors.tertiary colors.surface)
        ];
      };
    };
}
