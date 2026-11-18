{ inputs, ... }:
{
  # NixOS Base {{{1
  flake.modules.nixos.base =
    {
      pkgs,
      pkgs-stable,
      lib,
      config,
      ...
    }:
    {
      # Nix & Overlays {{{2
      nixpkgs.config.allowUnfree = true;

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
        min-free = 5 * 1024 * 1024 * 1024;
        http-connections = 50;
        connect-timeout = 5;
        stalled-download-timeout = 10;
        download-buffer-size = 128 * 1024 * 1024;
        allowed-users = [
          "@wheel"
          "skarphet"
        ];
      };

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      nix.optimise = {
        automatic = true;
        dates = [ "weekly" ];
      };

      nix.registry.nixpkgs.flake = inputs.nixpkgs;
      programs.nix-index-database.comma.enable = true;

      nixpkgs.overlays = [
        (final: prev: {
          tabiew = pkgs-stable.tabiew;
        })
        (final: prev: {
          aggregateModules =
            modules:
            (prev.aggregateModules modules).overrideAttrs (old: {
              postBuild =
                builtins.replaceStrings
                  [ "xargs -d'\\n' cat >> modules.cer" ]
                  [ "while read -r cer; do if [ -f \"$cer\" ]; then cat \"$cer\"; fi; done >> modules.cer" ]
                  old.postBuild;
            });
        })
      ];
      # }}}

      # Boot & Storage {{{2
      boot = {
        kernelPackages = pkgs.linuxPackages_zen;
        kernel.sysctl = {
          # network related
          "net.core.default_qdisc" = "fq";
          "net.ipv4.tcp_congestion_control" = "bbr";
          # security
          "kernel.unprivileged_bpf_disabled" = 1;
          "net.core.bpf_jit_harden" = 2;
          "kernel.dmesg_restrict" = 1;
          "kernel.kptr_restrict" = 2;
          "fs.protected_hardlinks" = 1;
          "fs.protected_symlinks" = 1;
          "fs.protected_fifos" = 2;
          "fs.protected_regular" = 2;
          "kernel.yama.ptrace_scope" = 1;
        };
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 10;
            editor = false;
            memtest86.enable = true;
          };
          efi.canTouchEfiVariables = true;
          timeout = 0;
        };
        extraModprobeConfig = ''
          # security
          install algif_aead /bin/false
        '';
        tmp.useTmpfs = true;
        tmp.cleanOnBoot = true;
        kernelParams = [
          "quiet"
          "loglevel=3"
          "systemd.show_status=auto"
          "rd.udev.log_level=3"
          "nowatchdog"
          "zswap.enabled=1"
          "dyndbg=\"func fw_log_firmware_info +p\""
          "initcall_blacklist=init_ima"
        ];
      };

      zramSwap = {
        enable = true;
        memoryPercent = 50;
      };

      services.fwupd.enable = true;
      services.fstrim.enable = true;
      services.smartd = {
        enable = true;
        notifications.wall.enable = true;
      };
      # }}}

      # Audio & Power {{{2
      security.rtkit.enable = true;
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        socketActivation = false;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      systemd.user.services.pipewire.wantedBy = [ "default.target" ];
      systemd.user.services.pipewire-pulse.wantedBy = [ "default.target" ];

      services.logind.settings = {
        Login = {
          HandlePowerKey = "poweroff";
          HandlePowerKeyLongPress = "halt";
          HandleLidSwitch = "suspend";
          HandleLidSwitchExternalPower = "suspend";
        };
      };
      # }}}

      # Localization & Documentation {{{2
      i18n.supportedLocales = [
        "C.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
        "tr_TR.UTF-8/UTF-8"
      ];
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "tr_TR.UTF-8";
        LC_IDENTIFICATION = "tr_TR.UTF-8";
        LC_MEASUREMENT = "tr_TR.UTF-8";
        LC_MONETARY = "tr_TR.UTF-8";
        LC_NAME = "tr_TR.UTF-8";
        LC_NUMERIC = "tr_TR.UTF-8";
        LC_PAPER = "tr_TR.UTF-8";
        LC_TELEPHONE = "tr_TR.UTF-8";
        LC_TIME = "tr_TR.UTF-8";
      };

      time.timeZone = "Europe/Istanbul";
      console.keyMap = "trq";
      services.timesyncd.enable = lib.mkDefault true;

      documentation = {
        enable = true;
        man.enable = true;
        dev.enable = true;
      };
      # }}}

      # Users & Login {{{2
      programs.fish.enable = true;
      users.users.skarphet = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "network"
          "video"
          "audio"
        ];
        packages = [ ];
        shell = pkgs.fish;
        initialPassword = "nixos";
      };
      users.users.root.initialPassword = "nixos";
      services.getty = {
        loginOptions = "-p -- skarphet";
        extraArgs = [
          "--skip-login"
          "--noclear"
          "--issue-file"
          "${config.users.users.skarphet.home}/.config/matugen/references/issue"
        ];
      };
      # }}}

      # Packages & Linker {{{2
      environment.systemPackages = with pkgs; [
        git
        wget
        curl
        htop
        bubblewrap
      ];

      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          wayland
          glib
          libGL
          libxkbcommon
          fontconfig
          freetype
          dbus
          libx11
          alsa-lib
          libpulseaudio
          libogg
          libvorbis
        ];
      };
      # }}}

      system.stateVersion = "25.11";
    };
  # }}}

  # Home Base {{{1
  flake.modules.homeManager.base =
    {
      pkgs,
      lib,
      config,
      env,
      ...
    }:
    let
      # Variable Definitions {{{2
      generalVars = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      xdgVars = {
        ADB_KEYS_PATH = "${config.xdg.dataHome}/android";
        GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
        LESSHISTFILE = "${config.xdg.stateHome}/less/history";
        NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
        PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
        W3M_DIR = "${config.xdg.stateHome}/w3m";
        WGETRC = "${config.xdg.configHome}/wgetrc";
        WINEPREFIX = "${config.xdg.dataHome}/wineprefixes/default";
        XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
        PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
        PYTHONUSERBASE = "${config.xdg.dataHome}/python";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
        GOPATH = "${config.xdg.dataHome}/go";
        GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
        NUGET_PACKAGES = "${config.xdg.cacheHome}/NuGetPackages";
        PNPM_HOME = "${config.xdg.dataHome}/pnpm";
        WEGORC = "${config.xdg.configHome}/wego/wegorc";
      };

      waylandVars = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        GDK_BACKEND = "wayland";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";
      };

      additionalPaths = [
        "${config.home.homeDirectory}/.local/bin"
        "${config.home.homeDirectory}/code/system"
      ];

      allSessionVars = xdgVars // waylandVars // generalVars;
      # }}}

      # Packages Without Config {{{2
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
      ];
      # }}}
    in
    {
      # Identity & Environment {{{2
      home.username = "skarphet";
      home.stateVersion = "25.11";
      home.homeDirectory = "/home/skarphet";

      home.sessionPath = additionalPaths;
      home.sessionVariables = allSessionVars;
      systemd.user.sessionVariables = allSessionVars // {
        PATH = "${lib.concatStringsSep ":" additionalPaths}:$PATH";
      };
      xdg.configFile."user-env.json".text = builtins.toJSON env;

      xdg.userDirs = {
        enable = true;
        createDirectories = false;
        setSessionVariables = false;

        desktop = "${config.home.homeDirectory}/desk";
        documents = "${config.home.homeDirectory}/doc";
        download = "${config.home.homeDirectory}/dl";
        music = "${config.home.homeDirectory}/mp3";
        pictures = "${config.home.homeDirectory}/img";
        publicShare = "${config.home.homeDirectory}/pub";
        templates = "${config.home.homeDirectory}";
        videos = "${config.home.homeDirectory}/vid";
        projects = "${config.home.homeDirectory}";
      };
      # }}}

      # Packages & Shell Abbrs {{{2
      home.packages = packagesWithoutConfig;
      dconf.enable = true;

      programs.fish.shellAbbrs = {
        cp = "xcp";
        find = "fd";
        hyprpicker = "hyprpicker -a";
        grep = "rg";
        df = "duf";
      };
      # }}}
    };
  # }}}
}

# -- vim: fdm=marker fdl=0
