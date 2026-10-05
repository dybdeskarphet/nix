{ pkgs, inputs, ... }:
{
  xdg.configFile."nvim".source = inputs.neovim-config;

  home.packages = with pkgs; [
    # general
    unzip
    ripgrep
    fd

    # treesitter & mason
    gcc
    gnumake
    nodejs
    python3
    dotnet-sdk_10
    tree-sitter

    # nix lsp
    nixd
    nixfmt

    # markdown
    pandoc
  ];
}
