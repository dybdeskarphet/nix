{ ... }:
{
  imports = [
    ../backup/rclone/system.nix
    ../backup/restic
    ../backup/syncthing
    ../dev/docker.nix
    ../dev/neovim/system.nix
    ../dev/ssh/system.nix
    ../hardware/opentabletdriver/system.nix
    ../utility/localsend.nix
    ../utility/openvpn
  ];
}
