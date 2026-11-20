{ ... }:
{
  imports = [
    ../dev/docker.nix
    ../dev/neovim/system.nix
    ../dev/ssh/system.nix
    ../hardware/opentabletdriver/system.nix
    ../utility/localsend.nix
    ../utility/openvpn
  ];
}
