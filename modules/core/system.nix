{
  pkgs,
  lib,
  env,
  ...
}:
{
  imports = [
    ../desktop/niri/system.nix
    ../desktop/sunshine
    ../desktop/fonts
    ../security/hyprlock/system.nix
    ../security/firejail/system.nix
    ../dev/neovim/system.nix
    ../hardware/tlp.nix
    ../hardware/openrazer/system.nix
    ../hardware/opentabletdriver/system.nix
    ../utility/rclone/system.nix
  ];
  # Essential Packages {{{
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
  ];
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
  };
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
  # }}}

  # Networking {{{1
  systemd.network.networks = {
    "10-home" = lib.mkIf (env.homeSSID != null) {
      matchConfig = {
        Name = "wlan0";
        SSID = env.homeSSID;
      };
      networkConfig.DHCP = "yes";
      dhcpV4Config = {
        SendHostname = true;
        Anonymize = false;
      };
    };

    "20-wired" = {
      matchConfig.Name = "en*";
      networkConfig.DHCP = "yes";
    };

    "25-wireless" = {
      matchConfig.Name = "wlan0";
      networkConfig = {
        DHCP = "yes";
        IgnoreCarrierLoss = "3s";
      };
      dhcpV4Config = {
        Anonymize = true;
        SendHostname = false;
      };
    };
  };
  # }}}

  # systemd-resolved {{{2
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        # TODO: Enable this after vm testing
        DNSOverTLS = false;
        DNSSEC = true;
        DNS = [ "9.9.9.9" ];
        FallbackDNS = [
          "1.0.0.1"
          "8.8.4.4"
        ];
      };
    };
  };
  # }}}

  # Main initialization {{{2
  networking = {
    hostName = "nixos";
    useNetworkd = true;
    useDHCP = true;
    wireless = {
      iwd = {
        enable = true;
        settings = {
          Network = {
            EnableIPv6 = false;
          };
          Settings = {
            AutoConnect = true;
          };
        };
      };
    };
  };
  # }}}
  # }}}

  # Bluetooth {{{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
        ControllerMode = "dual";
      };
      Policy = {
        AutoEnable = true;
      };
    };
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
    ];
  };
  # }}}

  # Localization / Time {{{
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "trq";
  services.timesyncd.enable = lib.mkDefault true;
  # }}}

  # Dynamic binary support {{{
  programs.nix-ld.enable = true;
  # }}}
}

# -- vim: fdm=marker fdl=0
