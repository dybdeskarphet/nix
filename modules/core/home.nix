{ pkgs, ... }:
let
  packagesWithoutConfig = with pkgs; [
    fzf
    keepassxc
  ];
in
{
  imports = [
    ../academic/rnote
    ../academic/write
    ../academic/zathura
    ../desktop/avizo
    ../desktop/awww
    ../desktop/chromium.nix
    ../desktop/clipboard.nix
    ../desktop/gtk
    ../desktop/hypridle.nix
    ../desktop/mako
    ../desktop/matugen
    ../desktop/niri/home.nix
    ../desktop/qt
    ../desktop/rofi
    ../desktop/waybar
    ../dev/fish
    ../dev/foot
    ../dev/git
    ../dev/gpg
    ../dev/lazygit
    ../dev/neovim/home.nix
    ../dev/sqlite.nix
    ../dev/tmux
    ../hardware/openrazer/home.nix
    ../hardware/opentabletdriver/home.nix
    ../security/firejail/home.nix
    ../security/hyprlock/home.nix
    ../utility/bat.nix
    ../utility/btop
    ../utility/cava
    ../utility/fastfetch
    ../utility/htop.nix
    ../utility/lsd.nix
    ../utility/mpv.nix
    ../utility/qalc.nix
    ../utility/rclone/home.nix
    ../utility/scripts
    ../utility/streamlink
    ../utility/yazi
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
