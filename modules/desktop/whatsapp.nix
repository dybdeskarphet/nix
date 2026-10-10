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
      "${config.xdg.configHome}/ZapZap"
      "${config.xdg.cacheHome}/ZapZap"
      "${config.xdg.dataHome}/ZapZap"
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
