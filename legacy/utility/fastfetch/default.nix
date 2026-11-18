{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fastfetch
  ];

  xdg.configFile."matugen/templates/fastfetch.jsonc".source = ./fastfetch.temp.jsonc;
}
