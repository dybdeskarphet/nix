{ pkgs, lib, ... }:
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
    LG_CONFIG_FILE = "$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/theme.yml";
  };
}
