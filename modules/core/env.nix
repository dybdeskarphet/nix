{ config, lib, ... }:
let
  generalVars = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  xdgVars = {
    ADB_KEYS_PATH = "${config.xdg.dataHome}/android";
    GNUPGHOME = "${config.xdg.configHome}/gnupg";
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    LESSHISTFILE = "${config.xdg.configHome}/less/history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
    W3M_DIR = "${config.xdg.stateHome}/w3m";
    WGETRC = "${config.xdg.configHome}/wgetrc";
    WINEPREFIX = "${config.xdg.dataHome}/wineprefixes/default";
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
    PYTHONUSERBASE = "${config.xdg.dataHome}/python";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
    GOPATH = "${config.xdg.dataHome}/go";
    GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
    NUGET_PACKAGES = "${config.xdg.cacheHome}/NuGetPackages";
    PNPM_HOME = "${config.xdg.dataHome}/pnpm";
    ANDROID_SDK_HOME = "${config.home.homeDirectory}/.android";
    ANDROID_AVD_HOME = "${config.home.homeDirectory}/.android";
    WEGORC = "${config.xdg.configHome}/wego/wegorc";
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

  sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/code/system"
  ];
in
{
  systemd.user.sessionVariables =
    xdgVars
    // waylandVars
    // generalVars
    // {
      PATH = "${lib.concatStringsSep ":" sessionPath}:$PATH";
    };

  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    setSessionVariables = false;

    desktop = "${config.home.homeDirectory}/desk";
    documents = "${config.home.homeDirectory}/doc";
    download = "${config.home.homeDirectory}/dl";
    music = "${config.home.homeDirectory}/mp3";
    pictures = "${config.home.homeDirectory}/img";
    publicShare = "${config.home.homeDirectory}/pub";
    templates = "${config.home.homeDirectory}";
    videos = "${config.home.homeDirectory}/vid";
    projects = "${config.home.homeDirectory}";
  };
}
