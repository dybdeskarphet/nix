{ pkgs, ... }:
{
  imports = [
    ./env.nix
    ../dev/fish
    ../dev/neovim/home.nix
    ../desktop/niri/home.nix
    ../hardware/opentabletdriver/home.nix
  ];
  # Clipboard {{{
  services.clipse = {
    enable = true;
    settings = {
      allowDuplicates = true;
      historySize = 100;
    };
  };

  home.packages = with pkgs; [
    wl-clipboard
  ];

  programs.fish.shellAbbrs = {
    toclipboard = "wl-copy";
  };
  # }}}
}

# -- vim: fdm=marker fdl=0
