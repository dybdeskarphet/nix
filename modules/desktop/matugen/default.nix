{ pkgs, ... }: {
  home.packages = with pkgs; [
    matugen
    skate
  ];

  xdg.configFile."matugen/config.toml".source = ./config.toml;
  xdg.configFile."matugen/references/gruvbox.txt".source = ./references/gruvbox.txt;
  xdg.configFile."matugen/references/monokaipro.txt".source = ./references/monokaipro.txt;
  xdg.configFile."matugen/templates/vimium.css".source = ./templates/vimium.css;
  xdg.configFile."matugen/templates/issue_template".source = ./templates/issue_template;
  xdg.configFile."matugen/templates/current_colors.txt".source = ./templates/current_colors.txt;
}
