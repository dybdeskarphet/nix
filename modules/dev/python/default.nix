{ ... }:
{
  xdg.configFile."matplotlib/matplotlibrc".text = ''
    backend: qtagg
  '';

  home.sessionVariables = {
    QT_API = "PyQt6";
  };
}
