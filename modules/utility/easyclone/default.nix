{ inputs, ... }:
{
  imports = [
    inputs.easyclone.homeManagerModules.default
  ];

  services.easyclone = {
    enable = true;

    backup = {
      remoteName = "GDrive-Compress";
      rootDir = "Backup";
      verboseLog = true;
      syncPaths = [ ];
      copyPaths = [ ];
    };

    rclone = {
      args = [
        "--update"
        "--verbose"
        "--transfers 4"
        "--checkers 16"
        "--contimeout 60s"
        "--timeout 300s"
        "--tpslimit 4"
        "--min-age 15s"
        "--drive-chunk-size 32M"
        "--retries 3"
        "--low-level-retries 10"
        "--stats 30s"
        "--exclude-from /home/skarphet/.config/easyclone/excludes.txt"
      ];
      concurrentLimit = 5;
    };

    daemon = {
      interval = 1;
      countdown = true;
    };

    # Optional: enable automated background backup via systemd user timer
    # timer = {
    #   enable = true;
    #   onCalendar = "daily";
    # };
  };
}
