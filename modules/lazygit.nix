{ ... }:
{
  home.lazygit =
    {
      pkgs,
      lib,
      colors,
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

          gui = {
            nerdFontsVersion = "3";

            theme = {
              activeBorderColor = [
                colors.on_surface
                "bold"
              ];
              inactiveBorderColor = [ colors.outline_variant ];
              searchingActiveBorderColor = [ colors.outline ];
              optionsTextColor = [ colors.secondary ];
              selectedLineBgColor = [ colors.primary_container ];
              cherryPickedCommitBgColor = [ colors.secondary_container ];
              cherryPickedCommitFgColor = [ colors.secondary ];
              unstagedChangesColor = [ colors.error ];
              defaultFgColor = [ colors.primary ];
            };

            spinner = {
              frames = [
                ""
                ""
                ""
                ""
                ""
                ""
              ];
              rate = 80;
            };
          };
        };
      };

      programs.fish.shellAbbrs = {
        lg = "lazygit";
      };
    };
}
