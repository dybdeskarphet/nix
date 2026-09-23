{ pkgs, env, ... }:
let
  packagesWithoutConfig = with pkgs; [
    fzf
    keepassxc
    bun
    xcp
    fd
    hyprpicker
    ripgrep
    android-tools
  ];
in
{
  imports = [
    ../academic/rnote
    ../academic/write
    ../academic/zathura
    ../academic/zotero.nix
    ../desktop/avizo
    ../desktop/awww
    ../desktop/chromium.nix
    ../desktop/clipboard.nix
    ../desktop/gtk
    ../desktop/hypridle.nix
    ../desktop/kanshi.nix
    ../desktop/mako
    ../desktop/matugen
    ../desktop/niri/home.nix
    ../desktop/qt
    ../desktop/rofi
    ../desktop/waybar
    ../dev/fish/home.nix
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
    ../utility/battery/home.nix
    ../utility/btop
    ../utility/cava
    ../utility/fastfetch
    ../utility/htop.nix
    ../utility/lsd.nix
    ../utility/mpv.nix
    ../utility/qalc.nix
    ../utility/rclone/home.nix
    ../utility/scrcpy.nix
    ../utility/scripts
    ../utility/streamlink
    ../utility/swayimg
    ../utility/syncthing
    ../utility/yazi
    ../utility/yt-dlp.nix
    ./env.nix
  ];

  # Install packages without config {{{
  home.packages = packagesWithoutConfig;
  # }}}

  # Enable programs without config {{{
  dconf.enable = true;
  # }}}

  # Dump env.nix to .config {{{
  xdg.configFile."user-env.json".text = builtins.toJSON env;
  # }}}

  # Abbrs for packages without config {{{
  programs.fish.shellAbbrs = {
    cp = "xcp";
    find = "fd";
    hyprpicker = "hyprpicker -a";
    grep = "rg";
  };
  # }}}
}

# -- vim: fdm=marker fdl=0
