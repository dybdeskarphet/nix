{ ... }:
{
  home.yazi =
    {
      pkgs,
      lib,
      config,
      colors,
      ...
    }:
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

        # Core & Plugins {{{
        package = pkgs.yazi.override {
          _7zz = pkgs._7zz-rar;
        };
        enableFishIntegration = true;
        shellWrapperName = "r";

        initLua = ''
          local colors = { primary = "${colors.primary}" }

          ${builtins.readFile ./init.lua}
        '';

        keymap = import ./_keymap.nix { inherit pkgs lib; };
        settings = import ./_settings.nix { inherit pkgs lib config; };

        plugins = {
          rnote = "${myPlugins}/rnote.yazi";
          svgz = "${myPlugins}/svgz.yazi";
          toggle-ratio = "${myPlugins}/toggle-ratio.yazi";
          smart-enter = pkgs.yaziPlugins.smart-enter;
          recycle-bin = pkgs.yaziPlugins.recycle-bin;
          toggle-pane = pkgs.yaziPlugins.toggle-pane;
          piper = pkgs.yaziPlugins.piper;
          vcs-files = pkgs.yaziPlugins.vcs-files;
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
        # }}}

        # Theme {{{
        theme = {
          mgr = {
            cwd = {
              fg = colors.primary;
              bold = true;
            };
            border_symbol = " ";
            hovered = {
              bold = true;
              reversed = true;
            };
            preview_hovered = {
              bold = true;
              reversed = true;
            };

            tab_active = {
              fg = colors.on_primary;
              bg = colors.primary;
              bold = true;
            };
            tab_inactive = {
              fg = colors.primary_fixed;
              bg = colors.on_primary_fixed;
            };
            tab_width = 1;

            find_keyword = {
              fg = colors.error;
              bold = true;
              italic = true;
              underline = true;
            };
            find_position = {
              fg = colors.error;
              bold = true;
              italic = true;
            };

            marker_copied = {
              fg = colors.tertiary_container;
              bg = colors.tertiary_container;
            };
            marker_cut = {
              fg = colors.error;
              bg = colors.error;
            };
            marker_marked = {
              fg = colors.error;
              bg = colors.error;
            };
            marker_selected = {
              fg = colors.tertiary;
              bg = colors.tertiary;
            };

            count_copied = {
              fg = colors.on_tertiary_container;
              bg = colors.tertiary_container;
            };
            count_cut = {
              fg = colors.on_error;
              bg = colors.error;
            };
            count_selected = {
              fg = colors.on_primary;
              bg = colors.tertiary;
            };
          };

          indicator = {
            parent = {
              reversed = true;
            };
            current = {
              reversed = true;
            };
            preview = {
              reversed = true;
            };
            padding = {
              open = "";
              close = "";
            };
          };

          mode = {
            normal_main = {
              bg = "reset";
              fg = colors.primary;
              bold = true;
            };
            normal_alt = {
              bg = "reset";
              fg = colors.primary;
            };

            select_main = {
              bg = colors.secondary;
              fg = colors.on_secondary;
              bold = true;
            };
            select_alt = {
              bg = colors.surface_variant;
              fg = colors.on_surface_variant;
            };

            unset_main = {
              bg = colors.tertiary;
              fg = colors.on_tertiary;
              bold = true;
            };
            unset_alt = {
              bg = colors.surface_variant;
              fg = colors.on_surface_variant;
            };

            progress_label = {
              bold = true;
            };
            progress_normal = {
              fg = colors.primary;
              bg = colors.surface_bright;
            };
            progress_error = {
              fg = colors.error;
              bg = colors.surface_bright;
            };

            permissions_t = {
              fg = colors.outline;
            };
            permissions_w = {
              fg = colors.tertiary_container;
            };
            permissions_x = {
              fg = colors.error;
            };
            permissions_r = {
              fg = colors.tertiary_fixed_dim;
            };
            permissions_s = {
              fg = colors.primary_fixed_dim;
            };
          };

          select = {
            border = {
              fg = colors.primary;
            };
            active = {
              fg = colors.tertiary;
              bold = true;
            };
            inactive = { };
          };

          input = {
            border = {
              fg = colors.primary;
            };
            value = {
              fg = colors.on_surface;
            };
          };

          completion = {
            border = {
              fg = colors.primary;
              bg = colors.on_primary;
            };
          };

          tasks = {
            border = {
              fg = colors.primary;
            };
            title = { };
            hovered = {
              fg = colors.tertiary_fixed;
              underline = true;
            };
          };

          which = {
            cols = 3;
            mask = {
              bg = colors.surface_bright;
            };
            cand = {
              fg = colors.primary;
            };
            rest = {
              fg = colors.on_primary;
            };
            desc = {
              fg = colors.on_surface;
            };
            separator = " ▶ ";
            separator_style = {
              fg = colors.on_surface;
            };
          };

          help = {
            on = {
              fg = colors.on_surface;
            };
            run = {
              fg = colors.on_surface;
            };
            footer = {
              fg = colors.on_secondary;
              bg = colors.secondary;
            };
          };

          tabs = {
            sep_inner = {
              open = "";
              close = "";
            };
            sep_outer = {
              open = "";
              close = "";
            };
          };

          status = {
            overall = { };
            sep_left = {
              open = "";
              close = "";
            };
            sep_right = {
              open = "";
              close = "";
            };
          };

          filetype.rules = [
            {
              mime = "image/*";
              fg = colors.cyan;
            }
            {
              mime = "{audio,video}/*";
              fg = colors.yellow;
            }
            {
              mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
              fg = colors.red;
            }
            {
              mime = "application/{pdf,doc,rtf}";
              fg = colors.green;
            }
            {
              url = "*";
              is = "orphan";
              bg = colors.red;
            }
            {
              url = "*";
              is = "exec";
              fg = colors.on_error_container;
            }
            {
              url = "*";
              is = "dummy";
              bg = colors.red;
            }
            {
              url = "*/";
              is = "dummy";
              bg = colors.red;
            }
            {
              mime = "inode/{,x-}empty";
              fg = colors.red;
            }
            {
              url = "*";
              fg = colors.on_surface;
            }
            {
              url = "*/";
              fg = colors.surface_tint;
            }
          ];
        };
        # }}}
      };
    };
}

# -- vim: fdm=marker fdl=0
