{
  pkgs,
  env,
  config,
  lib,
  ...
}:
let
  cld = "${config.users.users.skarphet.home}/cld";
  wrapperPkg = lib.findFirst (
    p: p.name == "restic-cloud-backup"
  ) null config.environment.systemPackages;
in
{
  environment.systemPackages = [
    pkgs.restic
    pkgs.rclone
  ];

  services.restic.backups.cloud-backup = {
    initialize = true;
    createWrapper = true;
    paths = env.restic.paths;
    repository = env.restic.repository;
    passwordFile = env.restic.passwordFile;
    rcloneConfigFile = env.restic.rcloneConfigFile;
    exclude = [
      # OS / file manager noise
      ".DS_Store"
      "Thumbs.db"
      "desktop.ini"

      # Locks
      ".~lock.*#"
      "~$*"
      "*.swp"
      "*.swo"
      "*~"
      ".#*"
      "#*#"

      # LaTeX
      "*.aux"
      "*.bbl"
      "*.blg"
      "*.fls"
      "*.fdb_latexmk"
      "*.log"
      "*.out"
      "*.synctex.gz"
      "*.toc"

      # Build targets & caches
      "_build"
      ".doctrees"
      ".cache"
      "*.tmp"
      "*.bak"

      # Python
      ".venv"
      "venv"
      "__pycache__"
      "*.pyc"
      "*.pyo"
      ".pytest_cache"
      ".mypy_cache"
    ];
    extraBackupArgs = [
      "-v"
    ];
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

  programs.fuse.userAllowOther = true;

  systemd.services.restic-mount = {
    description = "Restic Backup Read-Only Mount";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.fuse
    ];
    serviceConfig = {
      Type = "simple";
      User = "root";
      Group = "root";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${cld}";

      ExecStart = ''
        ${lib.getExe wrapperPkg} mount \
          --allow-other \
          ${cld}
      '';

      ExecStop = "${pkgs.fuse}/bin/fusermount -u ${cld}";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
