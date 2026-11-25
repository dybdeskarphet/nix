{ ... }:
{
  nixos.services =
    { env, config, ... }:
    {
      sops.secrets."syncthing/cert".owner = "skarphet";
      sops.secrets."syncthing/key".owner = "skarphet";

      services.syncthing = {
        enable = true;
        user = "skarphet";
        dataDir = "${config.users.users.skarphet.home}";
        configDir = "${config.users.users.skarphet.home}/.config/syncthing";
        cert = config.sops.secrets."syncthing/cert".path;
        key = config.sops.secrets."syncthing/key".path;
        openDefaultPorts = true;
        overrideDevices = true;
        overrideFolders = true;
        settings = env.syncthing;
      };
    };
}
