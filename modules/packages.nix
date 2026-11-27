{ ... }:
{
  # System Packages {{{
  nixos.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        wget
        curl
        htop
        bubblewrap
        sops
        age
        ssh-to-age
      ];
    };
  # }}}

  # Home Packages & Shell Abbrs {{{
  home.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        jq
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
        axel
        ffmpeg
        obs-studio
        borgbackup
        mermaid-cli
        duf
        mediainfo
        pavucontrol
        wev
        sirikali
        gocryptfs
        matugen
      ];

      programs.fish.shellAbbrs = {
        cp = "xcp";
        find = "fd";
        hyprpicker = "hyprpicker -a";
        grep = "rg";
        df = "duf";
      };
    };
  # }}}
}

# -- vim: fdm=marker fdl=0
