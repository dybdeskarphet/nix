{ ... }: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "tmux-256color";
    escapeTime = 0;
    historyLimit = 50000;
    customPaneNavigationAndResize = true;
    tmuxp.enable = true;
    extraConfig = builtins.readFile ./config.conf;
  };

  xdg.configFile."tmuxp".source = ./sessions;
  xdg.configFile."tmux/colors.conf".source = ./colors.conf;
}
