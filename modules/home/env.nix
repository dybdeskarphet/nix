{ ... }:
let
  generalVars = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  xdgVars = {
    ADB_KEYS_PATH = "$XDG_DATA_HOME/android";
    GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
    GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle";
    GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
    LESSHISTFILE = "$XDG_CONFIG_HOME/less/history";
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
    PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
    RXVT_SOCKET = "$XDG_RUNTIME_DIR/urxvtd";
    W3M_DIR = "$XDG_STATE_HOME/w3m";
    WGETRC = "$XDG_CONFIG_HOME/wgetrc";
    WINEPREFIX = "$XDG_DATA_HOME/wineprefixes/default";
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    PYTHONPYCACHEPREFIX = "$XDG_CACHE_HOME/python";
    PYTHONUSERBASE = "$XDG_DATA_HOME/python";
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
    GOPATH = "$XDG_DATA_HOME/go";
    GOMODCACHE = "$XDG_CACHE_HOME/go/mod";
    NUGET_PACKAGES = "$XDG_CACHE_HOME/NuGetPackages";
    PNPM_HOME = "$XDG_DATA_HOME/pnpm";
    ANDROID_SDK_HOME = "$HOME/.android";
    ANDROID_AVD_HOME = "$HOME/.android";
    WEGORC = "$XDG_CONFIG_HOME/wego/wegorc";
  };

  waylandVars = {
    CLUTTER_BACKEND = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    ELM_DISPLAY = "wl";
    GDK_BACKEND = "wayland";
    NO_AT_BRIDGE = "1";
    OZONE_PLATFORM = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };
in
{
  home.sessionVariables = xdgVars // waylandVars // generalVars;

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/code/system"
  ];
}
