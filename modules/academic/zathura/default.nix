{ ... }:
{
  programs.zathura = {
    enable = true;

    options = {
      recolor = true;
      recolor-keephue = true;
      recolor-lightcolor = "rgba(29,32,33,1)";
      recolor-darkcolor = "rgba(235,219,178,1)";

      selection-clipboard = "clipboard";
      incremental-search = true;
      search-hadjust = true;
      adjust-open = "width";
      font = "monospace 10";
    };

    extraConfig = ''
      # Include Matugen generated theme colors
      include colors

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

  # Link template for Matugen
  xdg.configFile."matugen/templates/zathura-colors".source = ./zathura.temp;
}
