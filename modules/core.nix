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

  # Bootloader {{{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      editor = false;
      memtest86.enable = true;
    };
    efi.canTouchEfiVariables = true;
    timeout = 0;
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

  # Networking {{{
  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
        rfkill unblock all
      '';
      deps = [ ];
    };
  };

  services.resolved.enable = true;
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

  # Documentation {{{
  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };
  # }}}

  # User definition {{{
  users.users.skarphet = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "network"
      "video"
      "audio"
      "input"
    ];
    packages = with pkgs; [
      firefox
      alacritty
    ];
    initialPassword = "nixos";
  };
  users.users.root.initialPassword = "nixos";
  # }}}

  # Localization / Time {{{
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "trq";
  services.timesyncd.enable = lib.mkDefault true;
  # }}}
}

# -- vim: fdm=marker fdl=0
