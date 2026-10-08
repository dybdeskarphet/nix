{
  pkgs,
  lib,
  config,
  ...
}:

let
  photogimpSrc = pkgs.fetchFromGitHub {
    owner = "Diolinux";
    repo = "PhotoGIMP";
    rev = "eca3a8f57b9944c063d043ce7c07524107b5292d";
    hash = "sha256-LNopObpXTkYbjqZMkwu0DhdLROuTkE+LYsnwdaICTd0=";
  };
in
{
  home.packages = with pkgs; [
    gimp
  ];

  home.activation.setupPhotoGIMP = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    GIMP_DIR="${config.xdg.configHome}/GIMP/3.2"
    if [ ! -d "$GIMP_DIR" ]; then
      $DRY_RUN_CMD mkdir -p "$GIMP_DIR"
      $DRY_RUN_CMD cp -rn ${photogimpSrc}/.config/GIMP/3.0/* "$GIMP_DIR/"
      $DRY_RUN_CMD chmod -R u+w "$GIMP_DIR"
    fi
  '';

  xdg.desktopEntries.photogimp = {
    name = "PhotoGIMP";
    genericName = "Image Editor (Photoshop Layout)";
    comment = "GIMP with Photoshop UI and shortcuts";
    exec = "gimp %U";
    icon = "${photogimpSrc}/.local/share/icons/hicolor/256x256/256x256.png";
    terminal = false;
    categories = [
      "Graphics"
      "2DGraphics"
      "RasterGraphics"
    ];
    mimeType = [
      "image/bmp"
      "image/gimp"
      "image/jpeg"
      "image/png"
      "image/tiff"
    ];
  };
}
