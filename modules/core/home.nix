{ pkgs, ... }:
let
  packagesWithoutConfig = with pkgs; [
    fzf
  ];
in
{
  imports = [
    ../desktop/chromium.nix
    ../desktop/clipboard.nix
    ../desktop/mako
    ../desktop/matugen
    ../desktop/niri/home.nix
    ../dev/fish
    ../dev/foot
    ../dev/neovim/home.nix
    ../dev/tmux
    ../hardware/opentabletdriver/home.nix
    ../utility/bat.nix
    ../utility/cava
    ../utility/easyclone
    ../utility/fastfetch
    ../utility/lsd.nix
    ../utility/streamlink
    ./env.nix
  ];

  # Install packages without config {{{
  home.packages = packagesWithoutConfig;
  # }}}

  # Enable programs without config {{{
  dconf.enable = true;
  # }}}
}

# -- vim: fdm=marker fdl=0
