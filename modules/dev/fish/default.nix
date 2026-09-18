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

  xdg.configFile = {
    "matugen/templates/fish_prompt.fish".source = ./templates/fish_prompt.temp.fish;
    "matugen/templates/sudo_prompt.fish".source = ./templates/sudo_prompt.temp.fish;
    "fish/functions/fish_right_prompt.fish".source = ./config/functions/fish_right_prompt.fish;
    "fish/functions/ipynb2py.fish".source = ./config/functions/ipynb2py.fish;
    "fish/functions/pdf2darkpdf.fish".source = ./config/functions/pdf2darkpdf.fish;
    "fish/functions/py2ipynb.fish".source = ./config/functions/py2ipynb.fish;
    "fish/functions/pasters.fish".source = ./config/functions/pasters.fish;
  };
}
