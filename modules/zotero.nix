{ ... }:
{
  home.gui =
    {
      pkgs-stable,
      config,
      sandbox,
      ...
    }:
    let
      sandboxedZotero = sandbox.wrap (
        { sloth, ... }:
        {
          imports = [
            sandbox.online
            sandbox.caps.x11
          ];

          app.package = pkgs-stable.zotero;
          flatpak.appId = "org.zotero.Zotero";

          bubblewrap.bind.rw = [
            (sloth.mkdir "${config.home.homeDirectory}/Zotero")
            (sloth.mkdir "${config.home.homeDirectory}/.zotero")
            config.xdg.userDirs.documents
            config.xdg.userDirs.download
          ];
        }
      );
    in
    {
      home.packages = [ sandboxedZotero ];
    };
}
