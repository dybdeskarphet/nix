{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    # 1. First-Class Signing Submodule
    signing = {
      key = "80860C9FC6584220";
      format = "openpgp";
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

  programs.fish.shellAbbrs = {
    gita = "git add .";
    gitc = "git commit -S";
    gitd = "git diff HEAD";
    gitp = "git push";
  };
}
