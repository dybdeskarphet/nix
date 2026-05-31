{ pkgs, lib, ... }:
{
  # Essential Packages {{{
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    curl
    htop
  ];
  # }}}

  # Boot {{{
  boot = {
    initrd.systemd.enable = true;
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
  };
  # }}}

  # Hardware {{{
  hardware = {
    cpu = {
      amd = {
        updateMicrocode = true;
      };
    };
    enableRedistributableFirmware = true;
  };
  # }}}

  # Networking {{{1
  # rfkill unblock {{{2
  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
        rfkill unblock all
      '';
      deps = [ ];
    };
  };
  # }}}

  # systemd-resolved {{{2
  services.resolved = {
    enable = true;
    fallbackDns = [
      "1.0.0.1"
      "8.8.4.4"
    ];
    dnsovertls = "true";
    dnssec = "true";
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

  # Documentation {{{
  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };
  # }}}

  # User definitions and configurations {{{1
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
    initialPassword = "nixos";
  };
  users.users.root.initialPassword = "nixos";
  services.getty.autologinUser = "skarphet";
  # }}}

  # Localization / Time {{{
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "trq";
  services.timesyncd.enable = lib.mkDefault true;
  # }}}
}

# -- vim: fdm=marker fdl=0
