{ pkgs, env, ... }:
{
  environment.systemPackages = [
    pkgs.restic
    pkgs.rclone
  ];

  services.restic.backups.cloud-backup = {
    initialize = true;
    paths = env.restic.paths;
    repository = env.restic.repository;
    passwordFile = env.restic.passwordFile;
    rcloneConfigFile = env.restic.rcloneConfigFile;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
