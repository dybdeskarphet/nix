{ ... }:
{
  nixos.services =
    { ... }:
    {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = false;
      };
      users.users.skarphet.extraGroups = [ "docker" ];
    };
}
