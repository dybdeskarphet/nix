{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit ((import ../../security/sandbox.nix { inherit pkgs lib; })) mkSandboxed;
in
{
  programs.swayimg = {
    enable = true;
    package = mkSandboxed {
      pkg = pkgs.swayimg;
      unshareNet = true;
      roBinds = [
        "${config.xdg.configHome}/swayimg"
        config.xdg.userDirs.pictures
        config.xdg.userDirs.download
      ];
    };
    initLua = builtins.readFile ./init.lua;
  };

  xdg.configFile."matugen/templates/swayimg.lua".source = ./swayimg.temp.lua;
}
