{ ... }:
{
  services.avizo.enable = true;
  xdg.configFile."matugen/templates/avizo.ini".source = ./avizo.temp.ini;
}
