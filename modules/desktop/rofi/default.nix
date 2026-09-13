{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rofi
    rofimoji
  ];

  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
        matching: "fuzzy";
        sorting-method: "fzf";
        sort: true;
        drun-match-fields: "name,generic,exec,categories,keywords";
    }

    @theme "${pkgs.writeText "fallback-theme" ""}" // or local share path
    @theme "/home/skarphet/.local/share/rofi/themes/basic_launcher/rounded_without_listview.rasi"
  '';

  xdg.configFile."rofi/launchpad.rasi".text = ''
    @theme "/home/skarphet/.local/share/rofi/themes/launchpad/launchpad.rasi"
  '';

  xdg.configFile."rofi/drawer.rasi".text = ''
    @theme "/home/skarphet/.local/share/rofi/themes/drawer/main.rasi"
  '';

  xdg.configFile."rofimoji.rc".text = ''
    action clipboard
  '';

  xdg.dataFile."rofi/themes/basic_launcher/rounded.rasi".source =
    ./themes/basic_launcher/rounded.rasi;
  xdg.dataFile."rofi/themes/basic_launcher/rounded_with_listview.rasi".source =
    ./themes/basic_launcher/rounded_with_listview.rasi;
  xdg.dataFile."rofi/themes/basic_launcher/rounded_without_listview.rasi".source =
    ./themes/basic_launcher/rounded_without_listview.rasi;
  xdg.dataFile."rofi/themes/launchpad/launchpad.rasi".source = ./themes/launchpad/launchpad.rasi;
  xdg.configFile."matugen/templates/rofi.rasi".source = ./themes/colors.temp.rasi;
}
