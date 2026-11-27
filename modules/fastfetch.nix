{ ... }:
{
  home.fastfetch =
    { colors, ... }:
    {
      programs.fastfetch = {
        enable = true;

        settings = {
          logo = {
            type = "small";
            color = {
              "1" = colors.source_color;
              "2" = colors.primary;
            };
          };

          display = {
            color = colors.primary;
            brightColor = true;
          };

          modules = [
            "title"
            "os"
            "kernel"
            "uptime"
            "packages"
            "shell"
            "wm"
          ];
        };
      };
    };
}
