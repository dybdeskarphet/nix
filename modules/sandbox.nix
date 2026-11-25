{ inputs, ... }:
{
  home.base =
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
    let
      mk = inputs.nixpak.lib.nixpak {
        inherit lib pkgs;
      };

      # Hardened desktop base: offline, silent, Wayland-only, GPU, fonts, themes, private /tmp & cache.
      base =
        { sloth, ... }:
        {
          imports = [ inputs.nixpak.nixpakModules.gui-base ];

          gpu.provider = lib.mkForce "nixos";
          timeZone.enable = true;
          fonts.fonts = osConfig.fonts.packages ++ [ pkgs.adwaita-fonts ];

          bubblewrap = {
            dieWithParent = true;
            newSession = true;
            sockets.pulse = lib.mkOverride 90 false;
            bind = {
              ro = [
                "/etc/passwd"
                "/etc/group"
              ];
              rw = lib.mkBefore [
                [
                  (sloth.mkdir (sloth.concat' sloth.appCacheDir "/tmp"))
                  "/tmp"
                ]
                [
                  (sloth.mkdir sloth.appCacheDir)
                  sloth.xdgCacheHome
                ]
              ];
            };
            env.XDG_DATA_DIRS = lib.mkForce (
              lib.makeSearchPath "share" [
                pkgs.adw-gtk3
                pkgs.papirus-icon-theme
                pkgs.adwaita-icon-theme
                pkgs.hicolor-icon-theme
                pkgs.shared-mime-info
              ]
            );
          };
        };

      # Composable capability traits
      caps = {
        net = {
          imports = [ inputs.nixpak.nixpakModules.network ];
        };

        audio = {
          bubblewrap.sockets = {
            pulse = lib.mkOverride 80 true;
            pipewire = true;
          };
        };

        x11 = {
          bubblewrap.sockets.x11 = true;
        };

        mpris = {
          imports = [ inputs.nixpak.nixpakModules.mpris2-player ];
        };

        notify = {
          dbus.policies."org.freedesktop.Notifications" = "talk";
        };

        tray = {
          dbus.policies = {
            "org.kde.StatusNotifierWatcher" = "talk";
            "org.freedesktop.StatusNotifierWatcher" = "talk";
          };
        };

        isolatedConfig =
          { sloth, ... }:
          {
            bubblewrap.bind.rw = lib.mkBefore [
              [
                (sloth.mkdir sloth.appConfigDir)
                sloth.xdgConfigHome
              ]
            ];
          };
      };

      # High-level trust/context profiles composed from base + caps
      profiles = {
        # Offline, silent, Wayland-only (viewers, editors, drawing, office)
        offline = {
          imports = [ base ];
        };

        # Networked productivity & research
        online = {
          imports = [
            base
            caps.net
          ];
        };

        # Local/streaming audio & video players/editors
        media = {
          imports = [
            base
            caps.audio
            caps.mpris
          ];
        };

        # Messaging & chat clients
        comms = {
          imports = [
            base
            caps.net
            caps.audio
            caps.notify
            caps.tray
            caps.x11
          ];
        };

        # Games & launchers
        gaming = {
          imports = [
            base
            caps.net
            caps.audio
            caps.x11
          ];
        };
      };
    in
    {
      _module.args.sandbox = {
        inherit mk caps;
        wrap = module: (mk { config = module; }).config.env;
      }
      // profiles;
    };
}
