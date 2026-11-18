{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit ((import ../security/sandbox.nix { inherit pkgs lib; })) mkSandboxed;
in
{
  programs.libreoffice = {
    enable = true;
    package = mkSandboxed {
      pkg = pkgs.libreoffice;
      unshareNet = true;
      roBinds = [
        "${config.xdg.configHome}/gtk-3.0"
        "${config.xdg.configHome}/dconf"
        "${config.xdg.configHome}/fontconfig"
      ];
      rwBinds = [
        "${config.xdg.configHome}/libreoffice"
        config.xdg.userDirs.documents
        config.xdg.userDirs.download
      ];
    };
  };
}
