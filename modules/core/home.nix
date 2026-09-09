{ pkgs, ... }:
let
  packagesWithoutConfig = with pkgs; [
    fzf
    lsd
  ];
in
{
  imports = [
    ./env.nix
    ../dev/fish
    ../dev/neovim/home.nix
    ../dev/tmux
    ../utility/bat.nix
    ../desktop/niri/home.nix
    ../desktop/matugen
    ../desktop/clipboard.nix
    ../hardware/opentabletdriver/home.nix
  ];
  # Install packages {{{
  home.packages = packagesWithoutConfig;
  # }}}
}

# -- vim: fdm=marker fdl=0
