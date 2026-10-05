{
  pkgs,
  env,
  lib,
  ...
}:
{
  programs.git = {
    enable = true;
    signing = env.git.signing;
    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      ".direnv/"
    ];

    settings = {
      user = env.git.user;
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

  xdg.configFile."git/allowed_signers" = lib.mkIf (env.git.allowedSigners or [ ] != [ ]) {
    text = (lib.concatStringsSep "\n" env.git.allowedSigners) + "\n";
  };

  programs.fish.shellAbbrs = {
    gita = "git add .";
    gitc = "git commit -S";
    gitd = "git diff HEAD";
    gitp = "git push";
  };
}
