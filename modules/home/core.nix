{ pkgs, ... }:
{
  imports = [
    ./env.nix
    ./fish/fish.nix
    ./neovim/neovim.nix
    ./niri/niri.nix
  ];
  # Clipboard {{{
  services.clipse = {
    enable = true;
    allowDuplicates = true;
    historySize = 100;
  };

  home.packages = with pkgs; [
    wl-clipboard
  ];
  # }}}
}
