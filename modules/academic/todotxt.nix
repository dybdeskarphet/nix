{
  pkgs,
  env,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    todo-txt-cli
  ];

  programs.fish.shellAbbrs = {
    "ted" = "nvim ${env.nvim.todotxt}";
    "t" = "todo.sh";
    "ta" = "todo.sh add";
    "tls" = "todo.sh ls";
  };

  xdg.configFile."todo/config".text = ''
    export TODO_DIR="${config.xdg.userDirs.documents}"
    export TODO_FILE="$TODO_DIR/todo.txt"
    export DONE_FILE="$TODO_DIR/done.txt"
    export REPORT_FILE="$TODO_DIR/report.txt"
  '';
}
