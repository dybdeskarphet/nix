{ ... }:
{
  home.file = {
    ".local/bin/screenshot" = {
      source = ./screenshot;
      executable = true;
    };
    ".local/bin/colors" = {
      source = ./colors;
      executable = true;
    };
    ".local/bin/network" = {
      source = ./network;
      executable = true;
    };
    ".local/bin/quickmenu" = {
      source = ./quickmenu;
      executable = true;
    };
  };
}
