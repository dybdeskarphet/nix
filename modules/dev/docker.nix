{ ... }:
{
  virtualisation.docker = {
    enable = true;
  };
  users.users.skarphet.extraGroups = [ "docker" ];
}
