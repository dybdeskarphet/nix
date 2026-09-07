{ pkgs, ... }:
{
  xdg.configFile."nvim".source = ./config;

  home.packages = with pkgs; [
    # general
    ripgrep
    fd

    # treesitter & mason
    gcc
    gnumake
    nodejs

    # nix lsp
    nixd
    nixfmt

    # markdown
    pandoc
  ];
}
