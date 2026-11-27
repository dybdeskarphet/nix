{ inputs, ... }:
{
  home.spicetify =
    {
      pkgs,
      config,
      colors,
      colorHelpers,
      sandbox,
      ...
    }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      s = colorHelpers.stripHash;

      sandboxedSpotify = sandbox.wrap (
        { sloth, ... }:
        {
          imports = [
            sandbox.media
            sandbox.caps.net
            sandbox.caps.x11
            sandbox.caps.notify
          ];

          app.package = config.programs.spicetify.spicedSpotify;
          flatpak.appId = "com.spotify.Client";

          dbus.policies."org.mpris.MediaPlayer2.spotify" = "own";

          bubblewrap.bind = {
            rw = [
              (sloth.mkdir "${config.xdg.configHome}/spotify")
            ];
            ro = [
              config.xdg.userDirs.music
            ];
          };
        }
      );
    in
    {
      imports = [
        inputs.spicetify-nix.homeManagerModules.default
      ];

      programs.spicetify = {
        # Keep false so spicetify-nix does not install unsandboxed spotify
        # alongside sandboxedSpotify; spicedSpotify is still built and wrapped above.
        enable = false;
        theme = spicePkgs.themes.text;

        customColorScheme = {
          accent = s colors.primary;
          accent-active = s colors.secondary;
          accent-inactive = s colors.surface_container_low;
          banner = s colors.primary;
          border-active = s colors.primary;
          border-inactive = s colors.outline_variant;
          header = s colors.outline;
          highlight = s colors.surface_container_high;
          main = s colors.surface;
          notification = s colors.blue;
          notification-error = s colors.error;
          subtext = s colors.on_surface_variant;
          text = s colors.on_surface;
        };
      };

      home.packages = [
        sandboxedSpotify
      ]
      ++ config.programs.spicetify.theme.extraPkgs;
    };
}
