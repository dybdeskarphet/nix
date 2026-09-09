{ pkgs, ... }: {
  home.packages = with pkgs; [
    wl-clipboard
  ];

  services.clipse = {
    enable = true;
    settings = {
      allowDuplicates = true;
      historySize = 100;
    };
  };

  programs.fish.shellAbbrs = {
    toclipboard = "wl-copy";
  };
}
