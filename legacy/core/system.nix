{ ... }:
{
  imports = [
    ../backup/rclone/system.nix
    ../backup/restic
    ../backup/syncthing
    ../desktop/chromium/system.nix
    ../desktop/fonts
    ../desktop/sunshine
    ../dev/docker.nix
    ../dev/neovim/system.nix
    ../dev/ssh/system.nix
    ../hardware/network.nix
    ../hardware/opentabletdriver/system.nix
    ../security/firewall
    ../security/hyprlock/system.nix
    ../utility/localsend.nix
    ../utility/openvpn
  ];
}
