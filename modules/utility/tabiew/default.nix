{ pkgs, ... }: {
  home.packages = [
    pkgs.tabiew
  ];

  xdg.configFile."matugen/templates/tabiew.toml".source = ./tabiew.temp.toml;
}
