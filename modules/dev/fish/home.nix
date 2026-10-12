{
  pkgs,
  lib,
  config,
  ...
}:
let
  nvim = lib.getExe pkgs.neovim;
  nh = lib.getExe pkgs.nh;
  tmuxp = lib.getExe pkgs.tmuxp;
  tput = lib.getExe' pkgs.ncurses "tput";
  cal = lib.getExe' pkgs.util-linux "cal";

  generalAbbrs = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    ":q" = "exit";
    "qq" = "exit";
    "q" = "exit";
    "Q" = "exit";

    "b" = "${tput} bel";
    "bell" = "${tput} bel";
    "cal" = "${cal} --monday";
    "date" = "LANG=tr_TR.UTF-8 date";
    "rm" = "rm -i";

    "sd" = "shutdown now";
    "suspend" = "systemctl suspend";
    "uefi" = "systemctl reboot --firmware-setup";

    "svim" = "sudo ${nvim}";
    "t" = "${nvim} ${config.home.homeDirectory}/doc/todo.txt";
  };

  nixAbbrs = {
    "ned" = "${tmuxp} load nix";
    "nev" = "sudo ${nvim} /etc/nixos/env.nix";

    "nbu" = "${nh} os switch --impure";
    "nts" = "${nh} os test --impure";
    "nup" = "${nh} os boot -u --commit-lock-file --impure";

    "ncl" = "${nh} clean all --keep 5";
    "npr" = "${nh} clean all --keep 1";

    "nsc" = "${nh} search";
  };
in
{
  programs.fish = {
    enable = true;
    loginShellInit = builtins.readFile ./init.fish;
    functions = {
      fish_greeting = "";
    };
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "you-should-use";
        src = pkgs.fishPlugins.fish-you-should-use;
      }
    ];
    shellAbbrs = generalAbbrs // nixAbbrs;
  };

  xdg.configFile = {
    "matugen/templates/fish_prompt.fish".source = ./templates/fish_prompt.temp.fish;
    "matugen/templates/sudo_prompt.fish".source = ./templates/sudo_prompt.temp.fish;
    "fish/functions" = {
      source = ./config/functions;
      recursive = true;
    };
  };

  home.packages = with pkgs; [
    wl-clipboard
    yt-dlp
  ];
}
