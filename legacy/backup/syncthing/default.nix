{ env, config, ... }:
{
  services.syncthing = {
    enable = true;
    user = "skarphet";
    dataDir = "${config.users.users.skarphet.home}";
    configDir = "${config.users.users.skarphet.home}/.config/syncthing";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    settings = env.syncthing;
  };
}
