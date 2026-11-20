{ ... }:
{
  home.gui =
    {
      pkgs,
      config,
      helpers,
      ...
    }:
    {
      programs.libreoffice = {
        enable = true;
        package = helpers.sandbox.mkSandboxed {
          inherit pkgs;
          pkg = pkgs.libreoffice;
          unshareNet = true;
          roBinds = [
            "${config.xdg.configHome}/gtk-3.0"
            "${config.xdg.configHome}/dconf"
            "${config.xdg.configHome}/fontconfig"
          ];
          rwBinds = [
            "${config.xdg.configHome}/libreoffice"
            config.xdg.userDirs.documents
            config.xdg.userDirs.download
          ];
        };
      };
    };
}
