{
  pkgs,
  env,
  config,
  lib,
  ...
}:
let
  fzf = lib.getExe pkgs.fzf;
in
{
  home.packages = with pkgs; [
    todo-txt-cli
  ];

  programs.fish.shellAbbrs = {
    "ted" = "nvim ${env.todotxt.current}";
  };

  xdg.configFile."todo/config".text = ''
    export TODO_DIR="${config.xdg.userDirs.documents}"
    export TODO_FILE="$TODO_DIR/todo.txt"
    export DONE_FILE="$TODO_DIR/.done.todo.txt"
    export REPORT_FILE="$TODO_DIR/.report.txt"
  '';

  programs.fish.functions = {
    tf = ''
      set -l todo_file "${env.todotxt.current}"
      set -l list_cmd "todo.sh -p ls | grep -E '^[0-9]+'"

      eval $list_cmd | ${fzf} \
        --prompt="Todo> " \
        --tiebreak=index \
        --header="Enter: Edit | Ctrl-X: Done | Ctrl-D: Delete | Ctrl-A: Add query" \
        --bind "ctrl-x:execute-silent(todo.sh do {1})+reload($list_cmd)" \
        --bind "ctrl-d:execute-silent(todo.sh -f del {1})+reload($list_cmd)" \
        --bind "ctrl-a:execute-silent(todo.sh add {q})+clear-query+reload($list_cmd)" \
        --bind "enter:execute(nvim +{1} $todo_file)"
    '';
  };
}
