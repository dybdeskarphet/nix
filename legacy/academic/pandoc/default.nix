{ pkgs, lib, ... }:
let
  inherit ((import ../../security/sandbox.nix { inherit pkgs lib; })) mkSandboxed;
in
{
  programs.pandoc = {
    enable = true;
    package = mkSandboxed {
      pkg = pkgs.pandoc;
      unshareNet = true;
      bindFiles = true;
    };
  };

  xdg.dataFile = {
    "pandoc/preamble.tex".source = ./preamble.tex;
    "pandoc/defaults/alerts.yaml".source = ./defaults/alerts.yaml;
    "pandoc/filters/github-alerts.lua".source = ./filters/github-alerts.lua;
  };
}
