{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
    rofi
    playerctl
    libnotify
    libqalculate
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
  xdg.configFile."niri/src" = {
    source = ./src;
    recursive = true;
  };
  xdg.configFile."matugen/templates/niri.kdl".source = ./colors.temp.kdl;
}
