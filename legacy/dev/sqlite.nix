{ pkgs, ... }:
{
  home.packages = with pkgs; [ sqlite ];

  xdg.configFile."sqlite3/sqliterc".text = ''
    -- Beautiful UTF-8 box drawing tables
    .mode box

    -- Always show headers
    .headers on

    -- Visible NULL values
    .nullvalue '∅'

    -- Custom prompt
    .prompt "sqlite> " "... > "

    -- Query execution timer
    .timer on
  '';
}
