{ pkgs, ... }: {
  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-dark";
      pager = "less -FR";
      style = "numbers,changes,header";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };

  programs.fish.shellAbbrs = {
    cat = "bat";
    man = "batman";
    diff = "batdiff";
    watch = "batwatch";
  };

  systemd.user.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };
}
