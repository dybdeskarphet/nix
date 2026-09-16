{ pkgs, ... }:
let
  razer-matugen = pkgs.writers.writePython3Bin "razer-matugen" {
    libraries = with pkgs.python3Packages; [
      openrazer
    ];
  } (builtins.readFile ./razer-matugen.py);
in
{
  home.packages = [ razer-matugen ];
  xdg.configFile."matugen/templates/openrazer.txt".source = ./openrazer.temp.txt;
}
