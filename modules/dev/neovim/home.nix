{
  pkgs,
  inputs,
  lib,
  env,
  ...
}:
{
  xdg.configFile."nvim" = {
    source = lib.cleanSourceWith {
      src = inputs.neovim-config;
      filter = path: _type: baseNameOf path != "nvim-pack-lock.json";
    };
    recursive = true;
  };

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
    typst
  ];
}
