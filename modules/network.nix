{ ... }:
{
  nixos.base =
    {
      pkgs,
      env,
      lib,
      ...
    }:
    {
      # Main Initialization & Firewall {{{
      networking = {
        hostName = "nixos";
        useNetworkd = true;
        wireless.iwd = {
          enable = true;
          settings.Settings.AutoConnect = true;
        };

        firewall = {
          enable = true;
          allowedTCPPorts = [
            8000
            8080
          ];
        };
      };
      # }}}

      # Network Settings {{{
      systemd.network.networks = {
        "10-home" = lib.mkIf (env.homeSSID != null) {
          matchConfig = {
            Type = "wlan";
            SSID = env.homeSSID;
          };
          networkConfig = {
            DHCP = "yes";
            IgnoreCarrierLoss = "3s";
          };
          dhcpV4Config = {
            SendHostname = true;
            Anonymize = false;
            RouteMetric = 600;
          };
          ipv6AcceptRAConfig.RouteMetric = 600;
        };

        "20-wired" = {
          matchConfig.Name = "en*";
          networkConfig.DHCP = "yes";
          dhcpV4Config.RouteMetric = 100;
          ipv6AcceptRAConfig.RouteMetric = 100;
        };

        "25-wireless" = {
          matchConfig.Type = "wlan";
          networkConfig = {
            DHCP = "yes";
            IgnoreCarrierLoss = "3s";
          };
          dhcpV4Config = {
            Anonymize = true;
            SendHostname = false;
            RouteMetric = 600;
          };
          ipv6AcceptRAConfig.RouteMetric = 600;
        };
      };
      # }}}

      # Wi-Fi Powersave & RFKill {{{
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="net", KERNEL=="wl*", RUN+="${pkgs.iw}/bin/iw dev %k set power_save off"
        ACTION=="add", SUBSYSTEM=="rfkill", ATTR{type}=="wlan", RUN+="${pkgs.util-linux}/bin/rfkill unblock wlan"
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
    };
}

# -- vim: fdm=marker fdl=0
