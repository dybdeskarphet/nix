{ pkgs, ... }:
let
  razer-matugen = pkgs.writers.writePython3Bin "razer-matugen" {
    libraries = with pkgs.python3Packages; [
      openrazer
    ];
    doCheck = false;
  } (builtins.readFile ./razer-matugen.py);
in
{
  home.packages = [ razer-matugen ];
  xdg.configFile."matugen/templates/razer-colors.json".source = ./razer-colors.temp.json;
}
