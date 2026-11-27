{ ... }:
{
  nixos.syncthing =
    {
      env,
      config,
      username,
      ...
    }:
    {
      sops.secrets."syncthing/cert".owner = username;
      sops.secrets."syncthing/key".owner = username;

      services.syncthing = {
        enable = true;
        user = username;
        dataDir = config.users.users.${username}.home;
        configDir = "${config.users.users.${username}.home}/.config/syncthing";
        cert = config.sops.secrets."syncthing/cert".path;
        key = config.sops.secrets."syncthing/key".path;
        openDefaultPorts = true;
        overrideDevices = true;
        overrideFolders = true;
        settings = env.syncthing;
      };
    };
}
