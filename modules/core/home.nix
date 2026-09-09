{ pkgs, ... }:
let
  utilityPackages = with pkgs; [
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
    ../dev/tmux
    ../utility/bat.nix
    ../desktop/niri/home.nix
    ../hardware/opentabletdriver/home.nix
  ];
  # Install packages {{{
  home.packages = utilityPackages;
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
