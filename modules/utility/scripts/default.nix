{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
    nmap
    qrencode
    rofi
    (tesseract.override {
      enableLanguages = [
        "eng"
        "tur"
      ];
    })
  ];

  home.file = {
    ".local/bin/borg_backup" = {
      source = ./borg_backup;
      executable = true;
    };
    ".local/bin/screenshot" = {
      source = ./screenshot;
      executable = true;
    };
    ".local/bin/colors" = {
      source = ./colors;
      executable = true;
    };
    ".local/bin/network" = {
      source = ./network;
      executable = true;
    };
    ".local/bin/quickmenu" = {
      source = ./quickmenu;
      executable = true;
    };
  };
}
