{ pkgs, ... }:
let
  utilityPackages = [
    "fzf"
    "lsd"
    "wl-clipboard"
  ];
in
{
  imports = [
    ./env.nix
    ../dev/fish
    ../dev/neovim/home.nix
    ../desktop/niri/home.nix
    ../hardware/opentabletdriver/home.nix
  ];
  # Install packages {{{
  home.packages = with pkgs; utilityPackages;
  # }}}

  # Clipboard {{{
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
  # }}}
}

# -- vim: fdm=marker fdl=0
