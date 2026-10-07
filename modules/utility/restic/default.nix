{ pkgs, env, ... }:
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
}
