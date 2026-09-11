{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Ahmet Arda Kavakci";
    userEmail = "ahmetardakavakci@gmail.com";
    signing = {
      key = "80860C9FC6584220";
      signByDefault = true;
    };

    settings = {
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

  # Co-locate your Git shell abbreviations here:
  programs.fish.shellAbbrs = {
    gita = "git add .";
    gitc = "git commit -S";
    gitd = "git diff HEAD";
    gitp = "git push";
  };
}
