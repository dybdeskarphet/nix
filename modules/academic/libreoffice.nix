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
  home.packages = [
    (mkSandboxed {
      pkg = pkgs.libreoffice;
      unshareNet = true;
      rwBinds = [
        "${config.xdg.configHome}/libreoffice"
        config.xdg.userDirs.documents
        config.xdg.userDirs.download
      ];
    })
  ];
}
