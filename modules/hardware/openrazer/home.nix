{ pkgs, ... }:
let
  razer-matugen = pkgs.writers.writePython3Bin "razer-matugen" {
    libraries = with pkgs.python3Packages; [
      openrazer
    ];
  } (builtins.readFile ./razer-matugen);
in
{
  home.packages = [ razer-matugen ];
}
