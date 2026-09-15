{ ... }:
{
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "matugen";
      theme_background = true;

      shown_boxes = "cpu proc";
      presets = "cpu:0:default,mem:0:tty,proc:1:default cpu:0:braille,proc:0:tty";

      proc_sorting = "memory";
      graph_symbol_proc = "tty";
      graph_symbol_mem = "tty";
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
  };

  xdg.configFile."matugen/templates/btop.theme".source = ./btop.temp.theme;
}
