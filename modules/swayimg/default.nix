{ ... }:
{
  home.gui =
    {
      pkgs,
      config,
      colors,
      mkNixPak,
      nixpakGuiBase,
      ...
    }:
    {
      programs.swayimg = {
        enable = true;
        package =
          (mkNixPak {
            config =
              { lib, ... }:
              {
                imports = [ nixpakGuiBase ];

                app.package = pkgs.swayimg;
                flatpak.appId = "org.swayimg.swayimg";
                dbus.enable = false;

                bubblewrap = {
                  network = false;
                  sockets.pulse = lib.mkForce false;
                  bind.ro = [
                    "${config.xdg.configHome}/swayimg"
                    config.xdg.userDirs.pictures
                    config.xdg.userDirs.download
                    "${config.home.homeDirectory}/code/nix/assets/wallpapers"
                  ];
                };
              };
          }).config.env;
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
