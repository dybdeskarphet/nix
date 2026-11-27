{ ... }:
{
  home.btop =
    {
      lib,
      colors,
      ...
    }:
    {
      programs.btop = {
        enable = true;

        settings = {
          color_theme = "custom";
          theme_background = true;

          shown_boxes = "cpu mem net proc";
          presets = "cpu:0:default,mem:0:tty,proc:1:default cpu:0:braille,proc:0:tty";
          show_disks = true;

          proc_sorting = "memory";
          graph_symbol = "braille";
          graph_symbol_cpu = "braille";
          graph_symbol_gpu = "braille";
          graph_symbol_mem = "braille";
          graph_symbol_net = "braille";
          graph_symbol_proc = "braille";
          proc_mem_bytes = true;
          proc_cpu_graphs = true;
          proc_colors = true;
          proc_gradient = true;

          vim_keys = true;
          rounded_corners = true;
          update_ms = 1800;
          show_cpu_watts = true;
          net_auto = false;
        };

        themes.custom =
          lib.concatStringsSep "\n" (
            lib.mapAttrsToList (k: v: ''theme[${k}]="${v}"'') {
              main_bg = "";
              main_fg = colors.on_surface;
              title = colors.primary;
              hi_fg = colors.secondary;
              selected_bg = colors.primary;
              selected_fg = colors.on_primary;
              inactive_fg = colors.on_surface_variant;
              proc_misc = colors.tertiary;
              cpu_box = colors.outline;
              mem_box = colors.outline;
              net_box = colors.outline;
              proc_box = colors.outline;
              div_line = colors.outline_variant;
              temp_start = colors.secondary;
              temp_mid = colors.primary;
              temp_end = colors.error;
              cpu_start = colors.secondary;
              cpu_mid = colors.primary;
              cpu_end = colors.error;
              free_start = colors.secondary;
              free_mid = "";
              free_end = colors.secondary_container;
              cached_start = colors.tertiary;
              cached_mid = "";
              cached_end = colors.tertiary_container;
              available_start = colors.primary;
              available_mid = "";
              available_end = colors.primary_container;
              used_start = colors.error;
              used_mid = "";
              used_end = colors.error_container;
              download_start = colors.secondary;
              download_mid = colors.primary;
              download_end = colors.tertiary;
              upload_start = colors.secondary;
              upload_mid = colors.primary;
              upload_end = colors.tertiary;
            }
          )
          + "\n";
      };
    };
}
