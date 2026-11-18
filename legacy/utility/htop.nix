{ pkgs, config, ... }:
{
  programs.htop = {
    enable = true;
    package = pkgs.htop-vim;

    settings = {
      color_scheme = 6;
      tree_view = 1;
      hide_kernel_threads = 1;
      highlight_deleted_exe = 1;
      highlight_megabytes = 1;
      highlight_threads = 1;
      delay = 15;

      sort_key = config.lib.htop.fields.PERCENT_MEM;
      tree_sort_key = config.lib.htop.fields.NICE;
      sort_direction = -1;
      tree_sort_direction = -1;

      fields = with config.lib.htop.fields; [
        PID
        USER
        PRIORITY
        NICE
        M_SIZE
        M_RESIDENT
        M_SHARE
        STATE
        PERCENT_CPU
        PERCENT_MEM
        TIME
        COMM
      ];
    }

    // (
      with config.lib.htop;
      leftMeters [
        (bar "LeftCPUs2")
        (bar "Memory")
        (bar "Swap")
      ]
    )

    // (
      with config.lib.htop;
      rightMeters [
        (bar "RightCPUs2")
        (text "Tasks")
        (text "LoadAverage")
        (text "Uptime")
      ]
    );
  };
}
