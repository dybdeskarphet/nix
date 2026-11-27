{ ... }:
{
  home.swayimg =
    {
      pkgs,
      config,
      colors,
      sandbox,
      ...
    }:
    {
      programs.swayimg = {
        enable = true;
        package = sandbox.wrap {
          imports = [ sandbox.offline ];

          app.package = pkgs.swayimg;
          flatpak.appId = "org.swayimg.swayimg";
          dbus.enable = false;

          bubblewrap.bind.ro = [
            "${config.xdg.configHome}/swayimg"
            config.xdg.userDirs.pictures
            config.xdg.userDirs.download
            "${config.home.homeDirectory}/code/nix/assets/wallpapers"
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
