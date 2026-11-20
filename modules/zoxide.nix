{ ... }:
{
  home.cli =
    { ... }:
    {
      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = [ "--cmd cd" ];
      };
    };
}
