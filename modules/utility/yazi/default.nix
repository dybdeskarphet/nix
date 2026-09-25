{ pkgs, lib, ... }:
let
  myPlugins = pkgs.fetchFromGitHub {
    owner = "dybdeskarphet";
    repo = "yazi-plugins";
    rev = "1c5e441085c8c8ea2168a29c94363c6f7938edb2";
    hash = "sha256-wVp8xLhHmVgBi8pEHQJlPefLlnd1j5CJNWeoV/xEeCc=";
  };
in
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "r";
    initLua = ./init.lua;
    keymap = import ./keymap.nix { inherit pkgs lib; };
    settings = import ./settings.nix { inherit pkgs lib; };

    plugins = {
      rnote = "${myPlugins}/rnote.yazi";
      svgz = "${myPlugins}/svgz.yazi";
      toggle-ratio = "${myPlugins}/toggle-ratio.yazi";
      smart-enter = pkgs.yaziPlugins.smart-enter;
      recycle-bin = pkgs.yaziPlugins.recycle-bin;
      toggle-pane = pkgs.yaziPlugins.toggle-pane;
      vcs-files = pkgs.yaziPlugins.vcs-files;
      relative-motions = pkgs.yaziPlugins.relative-motions;
      git = {
        package = pkgs.yaziPlugins.git;
        setup = true;
      };

      fg = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "fg.yazi";
        rev = "629ee224ab027a7dece548ebac3618a8a9b0bc16";
        hash = "sha256-ZoIYzXATPjLYSF7kH5UXgj6Ax1+HwL007iSG59x17qA=";
      };

      djvu = pkgs.fetchFromGitHub {
        owner = "Shallow-Seek";
        repo = "djvu-view.yazi";
        rev = "f218aa6870dba2eb8f26cf7675be125a502aac50";
        hash = "sha256-isg1Pd7u3m+TjsPjEWRljTUvybaOJZuspaHUxJig6qw=";
      };
    };

    extraPackages = with pkgs; [
      dragon-drop
      qrcp
      ouch
      zip
      fzf
      ripgrep
      bat
      rich-cli
    ];
  };

  xdg.configFile."matugen/templates/yazi.toml".source = ./templates/flavor.temp.toml;
  xdg.configFile."matugen/templates/colors.lua".source = ./templates/colors.temp.lua;
}
