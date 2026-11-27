{ ... }:
{
  home.cava =
    { colors, ... }:
    {
      programs.cava = {
        enable = true;

        settings.color = {
          background = "'default'";
          foreground = "'${colors.primary}'";

          gradient = 1;
          gradient_color_1 = "'${colors.primary_container}'";
          gradient_color_2 = "'${colors.primary}'";
          gradient_color_3 = "'${colors.on_primary_container}'";

          horizontal_gradient = 0;
          horizontal_gradient_color_1 = "'${colors.primary_container}'";
          horizontal_gradient_color_2 = "'${colors.primary}'";
          horizontal_gradient_color_3 = "'${colors.on_primary_container}'";
          horizontal_gradient_color_4 = "'${colors.primary}'";
          horizontal_gradient_color_5 = "'${colors.primary_container}'";
        };
      };
    };
}
