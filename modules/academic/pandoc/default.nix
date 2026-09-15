{ ... }:
{
  programs.pandoc = {
    enable = true;
  };

  xdg.dataFile = {
    "pandoc/preamble.tex".source = ./preamble.tex;
    "pandoc/defaults/alerts.yaml".source = ./defaults/alerts.yaml;
    "pandoc/filters/github-alerts.lua".source = ./filters/github-alerts.lua;
  };
}
