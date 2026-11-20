{ ... }:
{
  home.gui =
    { pkgs-stable, ... }:
    {
      home.packages = [ pkgs-stable.zotero ];
    };
}
