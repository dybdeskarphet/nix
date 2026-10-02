{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ../desktop/chromium/system.nix
    ../desktop/fonts
    ../desktop/niri/system.nix
    ../desktop/sunshine
    ../dev/fish/system.nix
    ../dev/neovim/system.nix
    ../hardware/bluetooth.nix
    ../hardware/network.nix
    ../hardware/openrazer/system.nix
    ../hardware/opentabletdriver/system.nix
    ../hardware/tlp.nix
    ../dev/docker.nix
    ../security/firewall
    ../security/hyprlock/system.nix
    ../utility/battery/system.nix
    ../utility/localsend.nix
    ../utility/rclone/system.nix
    ../utility/syncthing
  ];
  # Essential Packages {{{
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
  ];
  # }}}

  # I18N {{{
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
  # }}}

  # Boot {{{
  boot = {
    initrd = {
      systemd.enable = true;
      kernelModules = [
        "amdgpu"
        "vkms"
        "v4l2loopback"
      ];
    };
    kernelModules = [
      "vkms"
      "v4l2loopback"
    ];
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

      # realtek wi-fi stability
      options rtw88_pci disable_aspm=y
      options rtw88_core disable_lps_deep=y
    '';
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    tmp.useTmpfs = true;
    tmp.cleanOnBoot = true;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"

      "video=1920x1080"
      "acpi_backlight=amdgpu_bl1"

      "nowatchdog"
      "zswap.enabled=1"

      "btusb.enable_autosuspend=0"
      "rfkill.default_state=1"

      "dyndbg=\"func fw_log_firmware_info +p\""
    ];
  };
  # }}}

  # ZRAM {{{
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
  # }}}

  # fwupd {{{
  services.fwupd.enable = true;
  # }}}

  # Hardware {{{
  hardware = {
    graphics.enable = true;
    cpu = {
      amd = {
        updateMicrocode = true;
      };
    };
    enableRedistributableFirmware = true;
  };
  # SSD {{{2
  services.fstrim.enable = true;
  services.smartd = {
    enable = true;
    notifications.wall.enable = true;
  };
  # }}}
  # }}}

  # Audio {{{
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
  # }}}

  # Upower {{{
  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "Hibernate"; # or "PowerOff" / "Suspend"
  };
  # }}}

  # Documentation {{{
  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };
  # }}}

  # logind {{{
  services.logind.settings = {
    Login = {
      HandlePowerKey = "poweroff";
      HandlePowerKeyLongPress = "halt";
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };
  };
  # }}}

  # User definitions and configurations {{{1
  programs.fish.enable = true;
  users.users.skarphet = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "network"
      "video"
      "audio"
      "input"
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

  # Localization / Time {{{
  time.timeZone = "Europe/Istanbul";
  console.keyMap = "trq";
  services.timesyncd.enable = lib.mkDefault true;
  # }}}

  # Dynamic binary support {{{
  programs.nix-ld.enable = true;
  # }}}
}

# -- vim: fdm=marker fdl=0
