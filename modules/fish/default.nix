{ ... }:
{
  # NixOS {{{
  flake.modules.nixos.cli =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        dmidecode
        gnugrep
        gnused
      ];
    };
  # }}}

  # Home Manager {{{1
  flake.modules.homeManager.cli =
    {
      pkgs,
      lib,
      colors,
      helpers,
      ...
    }:
    let
      # Abbreviations {{{2
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
      };

      nixAbbrs = {
        "ned" = "${tmuxp} load nix";
        "nev" = "sudo ${nvim} /etc/nixos/env.nix";

        "nbu" = "${nh} os boot --impure";
        "nbun" = "${nh} os switch --impure";
        "nts" = "${nh} os test --impure";
        "nup" = "${nh} os boot -u --commit-lock-file --impure";

        "ncl" = "${nh} clean all --keep 5";
        "npr" = "${nh} clean all --keep 1";

        "nsc" = "${nh} search";
      };
      # }}}

      primaryRgb = helpers.colors.hexToRgb colors.primary;
      primaryRgbSeq = "${toString primaryRgb.r};${toString primaryRgb.g};${toString primaryRgb.b}";
    in
    {
      programs.fish = {
        enable = true;

        # Shell Init & Prompt {{{2
        loginShellInit = builtins.readFile ./init.fish;

        interactiveShellInit = ''
          if test "$COLORTERM" = truecolor
              set -gx SUDO_PROMPT (printf '\e[38;2;${primaryRgbSeq}m\e[48;2;${primaryRgbSeq}m\e[1;38;2;0;0;0msudo\e[0m\e[38;2;${primaryRgbSeq}m \e[1;38;2;255;255;255mpassword for %%u: \e[0m')
          else
              set -gx SUDO_PROMPT (string join ''' \
                  (tput bold) (tput setaf 1) 'sudo ' (tput sgr0) \
                  (tput setaf 7) 'password for %u: ' (tput sgr0))
          end

          set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
              --color=bg:-1,bg+:${colors.surface_container_highest} \
              --color=fg:${colors.on_surface},fg+:${colors.on_surface} \
              --color=hl:${colors.primary},hl+:${colors.primary} \
              --color=info:${colors.outline},prompt:${colors.primary} \
              --color=pointer:${colors.secondary},marker:${colors.tertiary} \
              --color=spinner:${colors.tertiary},header:${colors.primary} \
              --color=border:${colors.outline_variant}"
        '';

        functions = {
          fish_greeting = "";
          fish_prompt = ''
            set_color -o
            echo -n (prompt_pwd)
            set_color normal
            if fish_is_root_user
                echo -n " #"
            else
                echo -n " \$"
            end
            set_color -o "${colors.primary}"
            echo -n "  "
            set_color normal
          '';
        };
        # }}}

        # Plugins & Functions {{{2
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

      xdg.configFile."fish/functions" = {
        source = ./functions;
        recursive = true;
      };
      # }}}
    };
  # }}}
}

# -- vim: fdm=marker fdl=0
