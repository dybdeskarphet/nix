{ ... }:
{
  imports = [
    ../backup/rclone/system.nix
    ../backup/restic
    ../backup/syncthing
    ../desktop/chromium/system.nix
    ../desktop/fonts
    ../desktop/niri/system.nix
    ../desktop/sunshine
    ../dev/docker.nix
    ../dev/neovim/system.nix
    ../dev/ssh/system.nix
    ../hardware/bluetooth.nix
    ../hardware/network.nix
    ../hardware/openrazer/system.nix
    ../hardware/opentabletdriver/system.nix
    ../hardware/tlp.nix
    ../security/firewall
    ../security/hyprlock/system.nix
    ../utility/battery/system.nix
    ../utility/localsend.nix
    ../utility/nh
    ../utility/openvpn
  ];
}
