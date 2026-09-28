{ pkgs, lib, ... }:
let
  dragon = lib.getExe pkgs.dragon-drop;
  ouch = lib.getExe pkgs.ouch;
  zip = lib.getExe pkgs.zip;
  # localsend = lib.getExe pkgs.localsend-cli;
in
{
  mgr = {
    prepend_keymap = [
      # navigation
      {
        on = "l";
        run = "plugin smart-enter";
        desc = "Enter the child directory or open the file";
      }
      {
        on = "<Enter>";
        run = "plugin smart-enter";
        desc = "Enter the child directory or open the file";
      }
      {
        on = "<Right>";
        run = "plugin smart-enter";
        desc = "Enter the child directory or open the file";
      }
      {
        on = "o";
        run = "plugin smart-enter";
        desc = "Enter the child directory or open the file";
      }
      {
        on = "<Backspace>";
        run = "hidden toggle";
        desc = "Toggle the visibility of hidden files";
      }
      # rename operations
      {
        on = [
          "r"
          "r"
        ];
        run = "rename --cursor=before_ext";
        desc = "Rename selected file(s)";
      }
      {
        on = [
          "r"
          "s"
        ];
        run = "rename --hovered --empty=stem --cursor=start";
        desc = "Change the stem of selected file";
      }
      {
        on = [
          "r"
          "e"
        ];
        run = "rename --hovered --empty=ext --cursor=end";
        desc = "Change the extension of selected file";
      }
      # toggle ratio
      {
        on = "t";
        run = "plugin toggle-ratio";
        desc = "Toggle slim 2-pane large preview";
      }
      # dragon-drop
      {
        on = "<C-n>";
        run = "shell --orphan -- ${dragon} -x -a -T %s";
        desc = "Open with dragon (drag-and-drop)";
      }
      {
        on = [
          "c"
          "n"
        ];
        run = "shell --orphan -- ${dragon} -x -a -T %s";
        desc = "Open with dragon (drag-and-drop)";
      }
      {
        on = [
          "c"
          "N"
        ];
        run = ''shell --orphan -- cp -r "$(${dragon} -t -p -x)" .'';
        desc = "Open current directory with dragon as target (drag-and-drop)";
      }
      # localsend
      #      {
      #        on = [
      #          "c"
      #          "p"
      #        ];
      #        run = "shell --block -- sh -c 'for f in \"$@\"; do [ -f \"$f\" ] && set -- \"$@\" --file \"$f\"; shift;
      #  done; if [ $# -gt 0 ]; then ${localsend} \"$@\"; fi' _ %s";
      #        desc = "Send with localsend";
      #      }
      # compression
      {
        on = [
          "C"
          "z"
        ];
        run = "shell --interactive --cursor=76 -- sh -c 'for f; do set -- \"$@\" \"\${f#\"$PWD/\"}\"; shift;   
  done; ${zip} -r \"$0\" \"$@\"' .zip %s";
        desc = "Compress to .zip";
      }
      {
        on = [
          "C"
          "t"
        ];
        run = "shell --interactive --cursor=17 -- ${ouch} compress %s .tar.gz";
        desc = "Compress to .tar.gz with Ouch";
      }
      {
        on = [
          "C"
          "x"
        ];
        run = "shell --interactive --cursor=24 -- ${ouch} compress --slow %s .tar.xz";
        desc = "Compress to .tar.xz with Ouch";
      }
      {
        # chmod
        on = [
          "c"
          "m"
        ];
        run = "shell --interactive --cursor=6 -- chmod  %s";
        desc = "Chmod on selected files";
      }
    ];
  };
  input = {
    prepend_keymap = [
      {
        on = "<Esc>";
        run = "close";
        desc = "Cancel input";
      }
    ];
  };
}
