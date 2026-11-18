{ ... }:
{
  home.gui =
    { pkgs, colors, ... }:
    {
      home.packages = with pkgs; [
        wl-clipboard
      ];

      programs.fish.shellAbbrs = {
        toclipboard = "wl-copy";
      };

      services.clipse = {
        enable = true;

        settings = {
          allowDuplicates = true;
          historySize = 100;
          themeFile = "custom_theme.json";
        };

        theme = {
          UseCustom = true;
          TitleFore = colors.on_primary_container;
          TitleBack = colors.primary_container;
          TitleInfo = colors.secondary;
          NormalTitle = colors.on_surface;
          DimmedTitle = colors.on_surface_variant;
          SelectedTitle = colors.primary;
          NormalDesc = colors.on_surface_variant;
          DimmedDesc = colors.outline;
          SelectedDesc = colors.primary;
          StatusMsg = colors.tertiary;
          PinIndicatorColor = colors.tertiary;
          SelectedBorder = colors.primary;
          SelectedDescBorder = colors.primary;
          FilteredMatch = colors.tertiary;
          FilterPrompt = colors.secondary;
          FilterInfo = colors.secondary;
          FilterText = colors.on_surface;
          FilterCursor = colors.primary;
          HelpKey = colors.secondary;
          HelpDesc = colors.on_surface_variant;
          PageActiveDot = colors.primary;
          PageInactiveDot = colors.outline;
          DividerDot = colors.outline_variant;
          PreviewedText = colors.on_surface;
          PreviewBorder = colors.primary;
        };
      };
    };
}
