{ ... }:
{
  imports = [
    ../backup/rclone/system.nix
    ../backup/restic
    ../backup/syncthing
    ../desktop/chromium/system.nix
    ../desktop/sunshine
    ../dev/docker.nix
    ../dev/neovim/system.nix
    ../dev/ssh/system.nix
    ../hardware/opentabletdriver/system.nix
    ../security/hyprlock/system.nix
    ../utility/localsend.nix
    ../utility/openvpn
  ];
}
