{ ... }:
{
  home.gui =
    {
      pkgs,
      config,
      colors,
      helpers,
      sandbox,
      ...
    }:
    {
      programs.zathura = {
        enable = true;
        package = sandbox.wrap (
          { sloth, ... }:
          {
            imports = [ sandbox.offline ];

            app.package = pkgs.zathura;
            flatpak.appId = "org.pwmt.zathura";

            bubblewrap.bind = {
              ro = [
                "${config.xdg.configHome}/zathura"
                config.xdg.userDirs.documents
              ];
              rw = [
                (sloth.mkdir "${config.xdg.dataHome}/zathura")
                config.xdg.userDirs.download
              ];
            };
          }
        );

        options = {
          recolor = true;
          recolor-keephue = true;
          recolor-lightcolor = helpers.colors.hexToRgba 1 colors.surface;
          recolor-darkcolor = helpers.colors.hexToRgba 1 colors.on_surface;

          selection-clipboard = "clipboard";
          incremental-search = true;
          search-hadjust = true;
          adjust-open = "width";
          font = "monospace 10";

          default-bg = colors.surface;
          default-fg = colors.on_surface;

          statusbar-bg = colors.surface_container_low;
          statusbar-fg = colors.primary;

          inputbar-bg = colors.surface_container_low;
          inputbar-fg = colors.primary;

          notification-error-bg = colors.on_error;
          notification-error-fg = colors.error;

          notification-warning-bg = colors.primary_fixed;
          notification-warning-fg = colors.error_container;

          notification-bg = colors.surface_container_low;
          notification-fg = colors.primary;

          completion-bg = colors.surface_container_low;
          completion-fg = colors.primary;
          completion-group-bg = colors.surface_container_high;
          completion-group-fg = colors.outline;
          completion-highlight-bg = colors.primary;
          completion-highlight-fg = colors.surface_container_low;

          index-bg = colors.surface_container_low;
          index-fg = colors.on_surface;
          index-active-bg = colors.primary;
          index-active-fg = colors.on_primary;

          highlight-color = colors.primary_fixed;
          highlight-active-color = colors.primary_fixed_dim;

          render-loading = true;
          render-loading-bg = colors.surface;
          render-loading-fg = colors.on_surface;
        };

        extraConfig = ''
          # Fullscreen Toggle
          unmap f
          map f toggle_fullscreen
          map [fullscreen] f toggle_fullscreen

          # Zoom Controls (+ and -)
          map + zoom in
          map - zoom out
          map = zoom in
          map <KPAdd> zoom in
          map <KPSubtract> zoom out
          map [fullscreen] + zoom in
          map [fullscreen] - zoom out
          map [fullscreen] = zoom in
          map [fullscreen] <KPAdd> zoom in
          map [fullscreen] <KPSubtract> zoom out

          # Vim Movement & View Scrolling
          map h scroll left
          map j scroll down
          map k scroll up
          map l scroll right
          map [fullscreen] h scroll left
          map [fullscreen] j scroll down
          map [fullscreen] k scroll up
          map [fullscreen] l scroll right

          # Half-page scrolling
          unmap d
          map <C-d> scroll half-down
          map <C-u> scroll half-up
          map d scroll half-down
          map u scroll half-up
          map [fullscreen] <C-d> scroll half-down
          map [fullscreen] <C-u> scroll half-up
          map [fullscreen] d scroll half-down
          map [fullscreen] u scroll half-up

          # Full-page scrolling
          map <C-f> scroll full-down
          map <C-b> scroll full-up
          map <Space> scroll full-down
          map <S-Space> scroll full-up
          map [fullscreen] <C-f> scroll full-down
          map [fullscreen] <C-b> scroll full-up
          map [fullscreen] <Space> scroll full-down
          map [fullscreen] <S-Space> scroll full-up

          # Page navigation
          map J navigate next
          map K navigate previous
          map [fullscreen] J navigate next
          map [fullscreen] K navigate previous

          # Document jumps
          map gg goto top
          map G goto bottom
          map [fullscreen] gg goto top
          map [fullscreen] G goto bottom

          # View positioning on page
          map H scroll page-top
          map L scroll page-bottom
          map [fullscreen] H scroll page-top
          map [fullscreen] L scroll page-bottom

          # Jumplist navigation
          map <C-o> jumplist backward
          map <c-i> jumplist forward
        '';
      };
    };
}
