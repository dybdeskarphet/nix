{ ... }:
{
  home.gui =
    {
      pkgs,
      config,
      sandbox,
      ...
    }:
    let
      sandboxedKdenlive = sandbox.wrap (
        { sloth, ... }:
        {
          imports = [
            sandbox.media
            sandbox.caps.isolatedConfig
          ];

          app.package = pkgs.kdePackages.kdenlive;
          flatpak.appId = "org.kde.kdenlive";

          bubblewrap.bind.rw = [
            (sloth.mkdir "${config.xdg.dataHome}/kdenlive")
            config.xdg.userDirs.videos
            config.xdg.userDirs.music
            config.xdg.userDirs.pictures
            config.xdg.userDirs.download
          ];
        }
      );
    in
    {
      home.packages = [ sandboxedKdenlive ];
    };
}
