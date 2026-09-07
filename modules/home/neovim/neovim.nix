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
    nixfmt-rfc-style

    # markdown
    pandoc
  ];
}
