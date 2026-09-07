{ pkgs, ... }:
let
  generalAbbrs = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    ":q" = "exit";
    "Q" = "exit";
    "b" = "tput bel";
    "bell" = "tput bel";
    "cal" = "cal --monday";
    "date" = "LANG=tr_TR.UTF-8 date";
    "rm" = "rm -i";
    "sd" = "shutdown now";
    "suspend" = "systemctl suspend";
    "svim" = "sudo nvim";
    "uefi" = "systemctl reboot --firmware-setup";
  };
in
{
  programs.fish = {
    enable = true;
    loginShellInit = builtins.readFile ./init.fish;
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
    ];
    shellAbbrs = generalAbbrs;
  };

  xdg.configFile."fish/functions/fish_prompt.fish".source = ./prompt.fish;
  xdg.configFile."fish/functions/fish_right_prompt.fish".source = ./right_prompt.fish;
}
