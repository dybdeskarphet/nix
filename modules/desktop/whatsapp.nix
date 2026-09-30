{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zapzap
    (writeShellScriptBin "whatsapp" ''
      exec ${zapzap}/bin/zapzap "$@"
    '')
  ];
}
