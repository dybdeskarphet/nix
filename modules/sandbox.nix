{ inputs, ... }:
{
  home.sandbox =
    {
      pkgs,
      lib,
      config,
      osConfig,
      ...
    }:
    let
      mk = inputs.nixpak.lib.nixpak {
        inherit lib pkgs;
      };

      base =
        { sloth, ... }:
        {
          imports = [ inputs.nixpak.nixpakModules.gui-base ];

          gpu.provider = lib.mkForce "nixos";
          timeZone.enable = true;
          fonts.fonts =
            osConfig.fonts.packages
            ++ lib.optional ((config.gtk.font.package or null) != null) config.gtk.font.package;

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
              lib.makeSearchPath "share" (
                lib.unique (
                  lib.filter (p: p != null) [
                    (config.gtk.theme.package or null)
                    (config.gtk.iconTheme.package or null)
                    (config.gtk.cursorTheme.package or null)
                  ]
                  ++ [
                    pkgs.adwaita-icon-theme
                    pkgs.hicolor-icon-theme
                    pkgs.shared-mime-info
                  ]
                )
              )
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

      profiles = {
        offline = {
          imports = [ base ];
        };

        online = {
          imports = [
            base
            caps.net
          ];
        };

        media = {
          imports = [
            base
            caps.audio
            caps.mpris
          ];
        };

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
