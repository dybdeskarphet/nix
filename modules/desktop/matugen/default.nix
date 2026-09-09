{ pkgs, ... }: {
  home.packages = with pkgs; [
    matugen
  ];

  xdg.configFile."matugen/config.toml".source = ./config.toml;
  xdg.configFile."matugen/templates".source = ./templates;
  xdg.configFile."matugen/references".source = ./references;
}
