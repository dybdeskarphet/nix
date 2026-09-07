{ pkgs, ... }:
{
  xdg.configFile."nvim".source = ./config;

  home.packages = with pkgs; [
    # general
    unzip
    ripgrep
    fd

    # treesitter & mason
    gcc
    gnumake
    nodejs
    dotnet-runtime
    tree-sitter

    # nix lsp
    nixd
    nixfmt

    # markdown
    pandoc
  ];
}
