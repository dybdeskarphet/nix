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
    ../desktop/mako
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

  # Install packages without config {{{
  home.packages = packagesWithoutConfig;
  # }}}

  # Enable programs without config {{{
  programs.dconf.enable = true;
  # }}}
}

# -- vim: fdm=marker fdl=0
