{ pkgs, ... }: {
  home.packages = with pkgs; [
    tabiew
  ];

  xdg.configFile."matugen/templates/tabiew.toml".source = ./tabiew.temp.toml;
}
