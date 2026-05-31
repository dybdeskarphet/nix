{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done;
      }
    ];
  };

  xdg.configFile."fish/functions/fish_prompt.fish".source = ./prompt.fish;
  xdg.configFile."fish/functions/fish_right_prompt.fish".source = ./right_prompt.fish;
}
