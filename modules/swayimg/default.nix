{ ... }:
{
  home.gui =
    {
      pkgs,
      config,
      colors,
      helpers,
      ...
    }:
    {
      programs.swayimg = {
        enable = true;
        package = helpers.sandbox.mkSandboxed {
          inherit pkgs;
          pkg = pkgs.swayimg;
          unshareNet = true;
          roBinds = [
            "${config.xdg.configHome}/swayimg"
            config.xdg.userDirs.pictures
            config.xdg.userDirs.download
          ];
        };
        initLua = ''
          local palette = {
            background = "${colors.background}",
            surface = "${colors.surface}",
            surface_container = "${colors.surface_container}",
            surface_container_high = "${colors.surface_container_high}",
            surface_container_lowest = "${colors.surface_container_lowest}",
            primary = "${colors.primary}",
            secondary = "${colors.secondary}",
            tertiary = "${colors.tertiary}",
            on_surface = "${colors.on_surface}",
            outline = "${colors.outline}",
          }
        '' + builtins.readFile ./init.lua;
      };
    };
}
