{ ... }:
{
  flake.modules.homeManager.gui =
    {
      pkgs,
      lib,
      colors,
      helpers,
      ...
    }:
    let
      uoscColors = lib.concatStringsSep "," [
        "foreground=${helpers.colors.stripHash colors.primary}"
        "foreground_text=${helpers.colors.stripHash colors.on_primary}"
        "background=${helpers.colors.stripHash colors.surface}"
        "background_text=${helpers.colors.stripHash colors.on_surface}"
        "success=${helpers.colors.stripHash colors.tertiary}"
        "info=${helpers.colors.stripHash colors.secondary}"
        "warning=${helpers.colors.stripHash colors.primary_fixed}"
        "error=${helpers.colors.stripHash colors.error}"
        "curtain=${helpers.colors.stripHash colors.surface_container}"
        "match=${helpers.colors.stripHash colors.secondary_fixed_dim}"
        "heatmap=${helpers.colors.stripHash colors.tertiary_fixed}"
      ];
    in
    {
      programs.mpv = {
        enable = true;

        # Core & Profiles {{{
        scripts = with pkgs.mpvScripts; [
          uosc
          thumbfast
          sponsorblock
        ];

        config = {
          osc = false;
          osd-bar = false;
          border = false;

          vo = "gpu";
          hwdec = "auto";
          video-sync = "display-resample";
          sub-auto = "fuzzy";

          script-opts-append = "ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";
          ytdl-raw-options = "force-ipv4=";
          cache = true;
          demuxer-max-bytes = "150M";
          demuxer-max-back-bytes = "75M";
        };

        profiles = {
          pyradio = {
            volume = 50;
          };
          pyradio-volume = {
            volume = 20;
          };
        };
        # }}}

        # Keybindings {{{
        bindings = {
          "l" = "seek 5";
          "h" = "seek -5";
          "j" = "add volume -2";
          "k" = "add volume 2";
          "ctrl+b" = "cycle-values audio-channels stereo mono auto-safe";
          "ctrl+r" = "cycle_values video-rotate 90 180 270 0";

          "Alt+h" = "script-binding uosc/video     #! Select Quality > Video Quality";
          "Alt+a" = "script-binding uosc/audio     #! Select Quality > Audio Quality";
          "Alt+j" = "script-binding uosc/subtitles #! Select Quality > Subtitles";

          "Alt+c" = "script-binding uosc/chapters  #! Utils > Chapters";
          "Alt+p" = "script-binding uosc/playlist  #! Utils > Playlist";

          "Alt+m" = "script-binding uosc/menu";
          "Alt+t" = "script-binding sponsorblock/toggle";
          "Shift+Del" = "playlist-clear #! Utils > Clear Playlist";
          "o" = "script-binding uosc/open-file     #! Open file";
          "q" = "quit";

          "I" = "cycle-values vf \"format=yuv420p,negate\" \"\" #! Visual > Invert Colors";
        };
        # }}}

        # Script Opts {{{
        scriptOpts = {
          thumbfast = {
            max_height = 500;
            max_width = 500;
            scale_factor = 1;
            tone_mapping = "auto";
            overlay_id = 42;
            spawn_first = false;
            quit_after_inactivity = 0;
            network = true;
            audio = false;
            hwdec = false;
            direct_io = false;
            mpv_path = "mpv";
          };

          uosc = {
            timeline_style = "bar";
            color = uoscColors;
          };
        };
        # }}}
      };

      home.packages = with pkgs; [
        yt-dlp
      ];
    };
}

# -- vim: fdm=marker fdl=0
