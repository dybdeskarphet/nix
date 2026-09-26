{ pkgs, ... }: {
  home.packages = with pkgs; [
    wl-clipboard
  ];

  services.clipse = {
    enable = true;
    settings = {
      allowDuplicates = true;
      historySize = 100;
      themeFile = "custom_theme.json";
    };
  };

  programs.fish.shellAbbrs = {
    toclipboard = "wl-copy";
  };

  xdg.configFile."matugen/templates/clipse.json".source = ./clipse.temp.json;
}
