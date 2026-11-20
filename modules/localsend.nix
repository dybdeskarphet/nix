{ ... }:
{
  nixos.services =
    { ... }:
    {
      programs.localsend = {
        enable = true;
        openFirewall = true;
      };
    };
}
