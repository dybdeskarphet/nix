{ pkgs, ... }:
let
  packagesWithoutConfig = with pkgs; [
    fzf
    keepassxc
  ];
in
{
  imports = [
    ../desktop/chromium.nix
    ../desktop/clipboard.nix
    ../desktop/awww
    ../desktop/mako
    ../security/hyprlock/home.nix
    ../desktop/hypridle.nix
    ../security/firejail/home.nix
    ../desktop/gtk
    ../desktop/waybar
    ../desktop/qt
    ../desktop/matugen
    ../desktop/rofi
    ../desktop/niri/home.nix
    ../dev/fish
    ../dev/foot
    ../dev/git
    ../dev/lazygit
    ../dev/sqlite.nix
    ../dev/gpg
    ../dev/neovim/home.nix
    ../dev/tmux
    ../hardware/opentabletdriver/home.nix
    ../hardware/openrazer/home.nix
    ../utility/bat.nix
    ../utility/yazi
    ../utility/cava
    ../utility/btop
    ../utility/htop.nix
    ../utility/mpv.nix
    ../utility/fastfetch
    ../utility/rclone/home.nix
    ../utility/lsd.nix
    ../utility/streamlink
    ../utility/qalc.nix
    ../academic/rnote
    ../academic/zathura
    ../academic/write
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
