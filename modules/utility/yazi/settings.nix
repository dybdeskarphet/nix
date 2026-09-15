{ pkgs, lib, ... }:
let
  rnote = lib.getExe' pkgs.rnote "rnote";
  zathura = lib.getExe pkgs.zathura;
  libreoffice = lib.getExe pkgs.libreoffice;
  tabiew = lib.getExe' pkgs.tabiew "tw";
  mpv = lib.getExe pkgs.mpv;
  mediainfo = lib.getExe pkgs.mediainfo;
  vlc = lib.getExe pkgs.vlc;
  vscodium = lib.getExe pkgs.vscodium;
  sqlitebrowser = lib.getExe pkgs.sqlitebrowser;
  adb = lib.getExe' pkgs.android-tools "adb";
  rich = lib.getExe pkgs.rich-cli;
in
{
  mgr = {
    ratio = [
      1
      4
      3
    ];
    sort_by = "alphabetical";
    sort_reverse = false;
    sort_translit = true;
    linemode = "size";
  };

  preview = {
    max_width = 1920;
    max_height = 1080;
  };

  tasks = {
    preload_workers = 5;
    image_alloc = 536870912;
    image_bound = [
      0
      0
    ];
  };

  opener = {
    open_handwriting_rnote = [
      {
        run = "${rnote} %s";
        desc = "Open document with Rnote";
        orphan = true;
      }
    ];
    open_handwriting_write = [
      {
        run = "write_stylus %s";
        desc = "Open document with Write Stylus";
        orphan = true;
      }
    ];
    open_img = [
      {
        run = "nsxiv-rifle %s";
        desc = "Open image";
        orphan = true;
      }
    ];
    open_gimp = [
      {
        run = "gimp %s";
        desc = "Open with GIMP";
        orphan = true;
      }
    ];
    open_document = [
      {
        run = "${zathura} %s";
        desc = "Open document with Zathura";
        orphan = true;
      }
    ];
    open_office = [
      {
        run = "${libreoffice} %s";
        desc = "Open with LibreOffice";
        orphan = true;
      }
    ];
    open_tw = [
      {
        run = "${tabiew} %s";
        desc = "Open with tabiew";
        block = true;
      }
    ];
    play = [
      {
        run = "${mpv} --force-window=yes %s1";
        desc = "Play";
        orphan = true;
      }
      {
        run = "${mediainfo} %s1; echo 'Press enter to exit'; read _";
        block = true;
        desc = "Show media info";
      }
    ];
    play_vlc = [
      {
        run = "${vlc} %s1";
        desc = "Play with VLC";
        orphan = true;
      }
      {
        run = "${mediainfo} %s1; echo 'Press enter to exit'; read _";
        block = true;
        desc = "Show media info";
      }
    ];
    edit_vscode = [
      {
        run = "${vscodium} %s";
        desc = "Edit with VSCode";
        block = false;
      }
    ];
    convert_to_py = [
      {
        run = "ipynb2py %s";
        desc = "Convert it to .py file";
        block = false;
      }
    ];
    convert_to_ipynb = [
      {
        run = "py2ipynb %s";
        desc = "Convert it to .ipynb file";
        block = false;
      }
    ];
    install_apk = [
      {
        run = "${adb} install %s";
        desc = "Install the APK File";
        block = false;
      }
    ];
    convert_to_darkpdf = [
      {
        run = "pdf2darkpdf %s";
        desc = "Invert the colors of the PDF";
        block = false;
      }
    ];
    open_sqlitebrowser = [
      {
        run = "${sqlitebrowser} %s";
        desc = "Open with SQLite Browser";
        block = false;
      }
    ];
  };

  open = {
    prepend_rules = [
      {
        mime = "{trash/**,folder/trash}";
        use = [
          "open"
          "trash"
        ];
      }
      {
        mime = "application/sqlite3";
        use = "open_sqlitebrowser";
      }
      {
        url = "*.rnote";
        use = "open_handwriting_rnote";
      }
      {
        url = "*.svgz";
        use = "open_handwriting_write";
      }
      {
        mime = "video/mp4";
        use = [
          "play"
          "play_vlc"
        ];
      }
      {
        mime = "image/{xcf,adobe.photoshop}";
        use = "open_gimp";
      }
      {
        mime = "image/djvu";
        use = "open_document";
      }
      {
        mime = "image/*";
        use = [
          "open_img"
          "open_gimp"
        ];
      }
      {
        mime = "application/pdf";
        use = [
          "open_document"
          "open_handwriting_rnote"
          "convert_to_darkpdf"
        ];
      }
      {
        mime = "application/wine-extension-ini";
        use = "edit";
      }
      {
        mime = "application/{epub,epub+zip}";
        use = "open_document";
      }
      {
        mime = "application/{vnd.openxmlformats-officedocument.*,openxmlformats-officedocument.*,vnd.oasis.opendocument.*,oasis.opendocument.*,msword,vnd.ms-*}";
        use = "open_office";
      }
      {
        url = "*.{docx,doc,odt,xlsx,xls,ods,pptx,ppt,odp,rtf}";
        use = "open_office";
      }
      {
        url = "*.ipynb";
        use = [
          "edit"
          "edit_vscode"
          "convert_to_py"
        ];
      }
      {
        mime = "text/script.python";
        use = [
          "edit"
          "convert_to_ipynb"
        ];
      }
      {
        mime = "text/csv";
        use = [
          "edit"
          "open_office"
          "open_tw"
        ];
      }
      {
        mime = "application/android.package-archive";
        use = [
          "extract"
          "install_apk"
        ];
      }
    ];
  };

  plugin = {
    prepend_previewers = [
      {
        url = "*.rnote";
        run = "rnote";
      }
      {
        url = "*.svgz";
        run = "svgz";
      }
      {
        url = "**/.git/";
        run = "preview-git";
      }
      {
        mime = "application/{openxmlformats-officedocument.*,oasis.opendocument.*,ms-*,msword}";
        run = "office";
      }
      {
        url = "*.docx";
        run = "office";
      }
      {
        mime = "image/djvu";
        run = "djvu";
      }
      {
        url = "*.{csv,md,rst,ipynb}";
        run = ''piper -- ${rich} -a none -L "$1"'';
      }
      {
        mime = "application/json";
        run = ''piper -- ${rich} -a none -L "$1"'';
      }
    ];
  };
}
