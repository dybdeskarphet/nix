{ ... }:
{
  home.cli =
    { colors, ... }:
    {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        mouse = true;
        keyMode = "vi";
        prefix = "C-a";
        terminal = "tmux-256color";
        escapeTime = 0;
        historyLimit = 50000;
        customPaneNavigationAndResize = true;
        tmuxp.enable = true;

        extraConfig = ''
          ${builtins.readFile ./config.conf}

          set -g clock-mode-colour "${colors.primary}"

          # copy mode
          set -g mode-style 'fg=${colors.on_secondary},bg=${colors.secondary},bold'

          # panes
          set -g pane-border-style 'fg=${colors.outline_variant}'
          set -g pane-active-border-style 'fg=${colors.primary}'

          # statusbar
          set -g status-position bottom
          set -g status-justify left
          set -g status-style '''

          set -g status-left-length 40
          set -g status-left "#[fg=${colors.primary_container},bg=default]#[fg=${colors.on_primary_container},bg=${colors.primary_container}] #S#[fg=${colors.primary_container},bg=default] "

          set -g status-right-length 60
          set -g status-right "#[fg=${colors.primary_container},bg=default,bold]#[fg=${colors.on_primary_container},bg=${colors.primary_container},bold]%Y-%m-%d#[fg=${colors.primary_container},bg=default,bold] #[fg=${colors.primary_container},bg=default,bold]#[fg=${colors.on_primary_container},bg=${colors.primary_container},bold] %H:%M#[fg=${colors.primary_container},bg=default,bold] #[fg=${colors.tertiary_container},bg=default,bold]#[fg=${colors.on_tertiary_container},bg=${colors.tertiary_container},bold]󰁹 #(cat /sys/class/power_supply/BAT0/capacity)%%#[fg=${colors.tertiary_container},bg=default,bold]"

          set -g window-status-current-format '#[fg=${colors.primary},bg=default,bold,nounderscore]#I #[fg=${colors.on_surface},bold,nounderscore]#W #[fg=${colors.secondary},bold,nounderscore]#F'
          set -g window-status-format '#{?window_bell_flag,#[fg=${colors.error}],#[fg=${colors.outline}]}#I #W #{?window_bell_flag,,#F}'

          # messages
          set -g message-style 'fg=${colors.on_error_container},bg=${colors.error_container},bold'

          set -g window-status-bell-style '''
        '';
      };

      xdg.configFile."tmuxp".source = ./sessions;
    };
}
