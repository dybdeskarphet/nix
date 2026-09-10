{ pkgs, ... }:
let
  packagesWithoutConfig = with pkgs; [
    fzf
    lsd
  ];
in
{
  imports = [
    ../desktop/clipboard.nix
    ../desktop/matugen
    ../desktop/niri/home.nix
    ../desktop/chromium.nix
    ../dev/fish
    ../dev/neovim/home.nix
    ../dev/tmux
    ../hardware/opentabletdriver/home.nix
    ../utility/bat.nix
    ../utility/streamlink
    ../utility/cava
    ./env.nix
  ];
  # Install packages {{{
  home.packages = packagesWithoutConfig;
  # }}}
}

# -- vim: fdm=marker fdl=0
