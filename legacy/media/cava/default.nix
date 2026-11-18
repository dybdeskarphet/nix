{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cava
  ];

  xdg.configFile."matugen/templates/cava.ini".source = ./cava.temp.ini;
}
