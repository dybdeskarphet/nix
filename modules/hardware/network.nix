{
  pkgs,
  env,
  lib,
  ...
}:
{
  # Main initialization {{{
  networking = {
    hostName = "nixos";
    useNetworkd = true;
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
  # Network settings {{{
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
  # Wi-fi disable powersave {{{
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="${pkgs.iw}/bin/iw dev %k set power_save off"
  '';
  # }}}
  # systemd-resolved {{{
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNSOverTLS = true;
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
}

# -- vim: fdm=marker fdl=0
