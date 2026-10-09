{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit ((import ../security/sandbox.nix { inherit pkgs lib; })) mkSandboxed;

  sandboxedZapzap = mkSandboxed {
    pkg = pkgs.zapzap;
    binName = "zapzap";
    bindFiles = false;
    unshareNet = false;
    rwBinds = [
      "${config.xdg.configHome}/zapzap"
      "${config.xdg.dataHome}/zapzap"
      config.xdg.userDirs.download
    ];
  };
in
{
  home.packages = [
    sandboxedZapzap
    (pkgs.writeShellScriptBin "whatsapp" ''
      exec ${sandboxedZapzap}/bin/zapzap "$@"
    '')
  ];
}
