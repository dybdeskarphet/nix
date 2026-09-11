{ ... }:
{
  programs.lsd = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      classic = false;
      blocks = [
        "permission"
        "user"
        "group"
        "size"
        "date"
        "name"
      ];
      color = {
        when = "auto";
        theme = "default";
      };
      date = "+%Y-%m-%d %H:%M";
      dereference = false;
      display = "almost-all";
      icons = {
        when = "auto";
        theme = "fancy";
        separator = " ";
      };
      indicators = false;
      layout = "grid";
      recursion = {
        enabled = false;
        depth = 2;
      };
      size = "default";
      permission = "rwx";
      sorting = {
        column = "name";
        reverse = false;
        dir-grouping = "first";
      };
      no-symlink = false;
      total-size = false;
      hyperlink = "never";
      header = false;
    };
  };
}
