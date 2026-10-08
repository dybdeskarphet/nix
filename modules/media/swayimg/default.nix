{ ... }:
{
  programs.swayimg = {
    enable = true;
    initLua = builtins.readFile ./init.lua;
  };

  xdg.configFile."matugen/templates/swayimg.lua".source = ./swayimg.temp.lua;
}
