{ ... }:
{
  xdg.configFile."firejail" = {
    source = ./local;
    recursive = true;
  };
}
