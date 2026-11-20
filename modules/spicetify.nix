{ inputs, ... }:
{
  home.gui =
    {
      pkgs,
      colors,
      helpers,
      ...
    }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      s = helpers.colors.stripHash;
    in
    {
      imports = [
        inputs.spicetify-nix.homeManagerModules.default
      ];

      programs.spicetify = {
        enable = true;
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
    };
}
