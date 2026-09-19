{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDk59PDcSg4QstyRROvKn1zKvN5wrEWkXmBlDKEAprfN ahmetardakavakci@gmail.com";
      format = "ssh";
      signByDefault = true;
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      ".direnv/"
    ];

    settings = {
      user = {
        name = "Ahmet Arda Kavakci";
        email = "ahmetardakavakci@gmail.com";
      };

      init.defaultBranch = "main";
      core.autocrlf = "input";
      safe.directory = "/opt/flutter";
      pull.rebase = true;

      gpg.ssh = {
        program = "${pkgs.openssh}/bin/ssh-keygen";
        allowedSignersFile = "~/.config/git/allowed_signers";
      };

      http = {
        postBuffer = 104857600;
        version = "HTTP/1.1";
        lowSpeedLimit = 0;
        lowSpeedTime = 99999;
        keepAlive = true;
      };

      pack = {
        window = 10;
        depth = 50;
        windowSize = "10m";
      };

      "color \"diff\"" = {
        new = "#8ec07c";
        old = "#fb4934";
      };

      merge = {
        tool = "nvimdiff";
        conflictstyle = "zdiff3";
      };

      mergetool = {
        prompt = false;
      };
    };
  };

  xdg.configFile."git/allowed_signers".text = ''
    ahmetardakavakci@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDk59PDcSg4QstyRROvKn1zKvN5wrEWkXmBlDKEAprfN ahmetardakavakci@gmail.com
    ahmetardakavakci@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+AJiAS28yo0PB5wc1eiBDplv2AGolgq+cPu6R4WDm/ skarphet@arch
  '';

  programs.fish.shellAbbrs = {
    gita = "git add .";
    gitc = "git commit -S";
    gitd = "git diff HEAD";
    gitp = "git push";
  };
}
