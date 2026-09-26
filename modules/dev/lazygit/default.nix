{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        diffRenderers = [
          {
            command = "${lib.getExe pkgs.delta} --syntax-theme gruvbox-dark --paging=never";
          }
        ];
        overrideGpg = true;
      };
    };
  };

  xdg.configFile."matugen/templates/lazygit.yml".source = ./theme.temp.yml;

  systemd.user.sessionVariables = {
    LG_CONFIG_FILE = "${config.xdg.configHome}/lazygit/config.yml,${config.xdg.configHome}/lazygit/theme.yml";
  };

  programs.fish.shellAbbrs = {
    lg = "lazygit";
  };
}
