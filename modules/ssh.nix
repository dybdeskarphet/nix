{ ... }:
{
  nixos.ssh =
    { ... }:
    {
      services.gnome.gcr-ssh-agent.enable = false;
    };

  home.ssh =
    { env, lib, ... }:
    {
      services.ssh-agent.enable = true;

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        settings = lib.mkMerge [
          {
            "*" = {
              ServerAliveInterval = 60;
              ServerAliveCountMax = 3;
            };
          }
          (env.sshHosts or { })
        ];
      };
    };
}
