{ ... }:
{
  # System Packages {{{
  nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        wget
        curl
        htop
        bubblewrap
      ];
    };
  # }}}

  # Home Packages & Shell Abbrs {{{
  home.base =
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
        kdePackages.kdenlive
        mediainfo
        pavucontrol
        super-productivity
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
