{ pkgs, ... }:
let
  iniFormat = pkgs.formats.ini { };
in
{
  home.packages = with pkgs; [
    libqalculate
  ];

  xdg.configFile."qalculate/qalc.cfg".source = iniFormat.generate "qalc.cfg" {
    General = {
      save_config = 0;
      save_mode_on_exit = 0;
      save_definitions_on_exit = 0;
      dot_as_separator = 0;
    };

    Mode = {
      calculate_as_you_type = 1;
    };
  };
}
