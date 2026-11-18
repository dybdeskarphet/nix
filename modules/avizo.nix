{ ... }:
{
  flake.modules.homeManager.desktop =
    { colors, helpers, ... }:
    {
      services.avizo = {
        enable = true;

        settings.default = {
          time = 1.5;
          y-offset = 0.5;
          x-offset = 0.5;
          border-radius = 10;
          border-width = 0;
          fade-in = 0.2;
          fade-out = 0.3;

          background = helpers.colors.hexToRgba 0.8 colors.primary;
          border-color = helpers.colors.hexToRgba 0.8 colors.outline;
          bar-fg-color = helpers.colors.hexToRgba 0.8 colors.background;
        };
      };
    };
}
