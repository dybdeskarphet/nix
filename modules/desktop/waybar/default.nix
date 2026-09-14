{ pkgs, ... }:
let
  waybar-scripts = pkgs.writeScriptBin "waybar-scripts" (builtins.readFile ./scripts/waybar-scripts);
in
{
  home.packages = with pkgs; [
    waybar
    waybar-scripts
    jq
    libnotify
    wl-clipboard
    wireplumber
    bluez
    radeontop
    impala
  ];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  xdg.configFile."waybar/style.css".source = ./style.css;
  xdg.configFile."matugen/templates/colors.css".source = ./templates/colors.temp.css;
  xdg.configFile."matugen/templates/waybar.jsonc".source = ./templates/waybar.temp.jsonc;
}
