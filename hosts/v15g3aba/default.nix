{
  username = "skarphet";

  features = [
    # system
    "boot"
    "hardware"
    "locale"
    "login"
    "network"
    "nix"
    "packages"
    "sandbox"
    "scripts"
    "sops"
    "user"

    # hardware & peripherals
    "battery"
    "bluetooth"
    "openrazer"
    "opentabletdriver"
    "sunshine"

    # cli
    "antigravity"
    "bat"
    "btop"
    "cava"
    "fastfetch"
    "fish"
    "git"
    "gpg"
    "htop"
    "lazygit"
    "lsd"
    "neovim"
    "python"
    "qalc"
    "scrcpy"
    "sqlite"
    "ssh"
    "tabiew"
    "tmux"
    "todotxt"
    "yazi"
    "yt-dlp"
    "zoxide"

    # gui
    "avizo"
    "awww"
    "brave"
    "clipboard"
    "fonts"
    "foot"
    "gimp"
    "gtk"
    "hypridle"
    "hyprlock"
    "kdenlive"
    "libreoffice"
    "mako"
    "mpv"
    "niri"
    "prismlauncher"
    "qt"
    "rnote"
    "spicetify"
    "steam"
    "streamlink"
    "swayimg"
    "walker"
    "waybar"
    "whatsapp"
    "write"
    "zathura"
    "zotero"

    # services
    "docker"
    "localsend"
    "openvpn"
    "rclone"
    "restic"
    "syncthing"
  ];

  nixosModules = [ ./nixos.nix ];
  homeModules = [ ./home.nix ];
}
