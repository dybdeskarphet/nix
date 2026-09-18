{ ... }:
{
  services.avizo.enable = true;
  xdg.configFile."matugen/templates/avizo.ini" = ./avizo.temp.ini;
}
