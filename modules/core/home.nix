{
  pkgs,
  env,
  inputs,
  ...
}:
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
    uv
    glib
    gsettings-desktop-schemas
    python3
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli
    axel
    libreoffice
    ffmpeg
    obs-studio
    spotify
    borgbackup
    mermaid-cli
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
    ../desktop/chromium/home.nix
    ../desktop/clipboard
    ../desktop/gtk
    ../desktop/hypridle.nix
    ../desktop/kanshi.nix
    ../desktop/mako
    ../desktop/matugen
    ../desktop/niri/home.nix
    ../desktop/qt
    ../desktop/rofi
    ../desktop/waybar
    ../desktop/whatsapp.nix
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
    ../media/cava
    ../media/gimp
    ../media/mpv
    ../media/streamlink
    ../media/swayimg
    ../media/yt-dlp.nix
    ../security/hyprlock/home.nix
    ../utility/bat.nix
    ../utility/battery/home.nix
    ../utility/btop
    ../utility/fastfetch
    ../utility/htop.nix
    ../utility/lsd.nix
    ../utility/qalc.nix
    ../utility/rclone/home.nix
    ../utility/scrcpy.nix
    ../utility/scripts
    ../utility/tabiew
    ../utility/yazi
    ../utility/zoxide.nix
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
