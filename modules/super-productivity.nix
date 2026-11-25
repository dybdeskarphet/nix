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
      sandboxedSuperProductivity = sandbox.wrap (
        { sloth, ... }:
        {
          imports = [
            sandbox.offline
            sandbox.caps.x11
            sandbox.caps.notify
          ];

          app.package = pkgs.super-productivity;
          flatpak.appId = "com.super_productivity.SuperProductivity";

          bubblewrap.bind.rw = [
            (sloth.mkdir "${config.xdg.configHome}/superProductivity")
            config.xdg.userDirs.documents
            config.xdg.userDirs.download
          ];
        }
      );
    in
    {
      home.packages = [ sandboxedSuperProductivity ];
    };
}
