# Example schema for `inputs.private/env.nix`.
# Expected private repo layout:
#   nix-private/
#   ├── .sops.yaml
#   ├── env.nix
#   ├── hardware-configuration.nix
#   └── secrets.yaml  # keys: restic/{password,rclone_conf}, syncthing/{cert,key}, openvpn/<profile>
{
  username = "user";
  homeSSID = "MyHomeWiFi"; # or null
  wallpaper = "gashadokuro.png"; # filename in assets/wallpapers/, or null
  system = "x86_64-linux";

  openvpn = {
    profiles = [
      # Must match keys under `openvpn:` in secrets.yaml
      "work"
    ];
  };

  sshHosts = {
    # Passed directly to programs.ssh.matchBlocks
    # my-server = {
    #   HostName = "192.168.1.10";
    #   User = "user";
    #   Port = 22;
    # };
  };

  todotxt = {
    current = "/home/user/doc/todo.txt";
  };

  borg = {
    repo = "/mnt/backup/borg_backups";
    items = [
      "/home/user/doc"
    ];
  };

  screenshot = {
    dir = "~/img/ss";
    ocr_lang = "eng";
  };

  hyprlock = {
    pp = "/home/user/img/avatar.jpg";
  };

  git = {
    signing = {
      key = "ssh-ed25519 AAAA... user@example.com";
      format = "ssh";
      signByDefault = true;
    };
    user = {
      name = "Your Name";
      email = "user@example.com";
    };
    allowedSigners = [
      "user@example.com ssh-ed25519 AAAA... user@example.com"
    ];
  };

  restic = {
    paths = [
      "/home/user/doc"
    ];
    repository = "rclone:Remote:Backups/Nix";
  };

  syncthing = {
    # Passed directly to services.syncthing.settings (devices, folders, etc.)
    devices = { };
    folders = { };
  };
}
