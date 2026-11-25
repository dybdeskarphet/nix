{ ... }:
{
  # NixOS User {{{
  nixos.base =
    { pkgs, ... }:
    {
      programs.fish.enable = true;
      users.users.skarphet = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "network"
          "video"
          "audio"
        ];
        shell = pkgs.fish;
        initialPassword = "nixos";
      };
      users.users.root.initialPassword = "nixos";
    };
  # }}}

  # Home Identity & Environment {{{
  home.base =
    {
      lib,
      config,
      env,
      ...
    }:
    let
      homeDir = config.home.homeDirectory;
      inherit (config.xdg)
        cacheHome
        configHome
        dataHome
        stateHome
        ;

      additionalPaths = [
        "${homeDir}/.local/bin"
        "${homeDir}/code/system"
      ];

      allSessionVars = {
        # General
        EDITOR = "nvim";
        VISUAL = "nvim";

        # Wayland
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        GDK_BACKEND = "wayland";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";

        # XDG cleanups
        ADB_KEYS_PATH = "${dataHome}/android";
        CARGO_HOME = "${dataHome}/cargo";
        GOMODCACHE = "${dataHome}/go/mod";
        GOPATH = "${dataHome}/go";
        GRADLE_USER_HOME = "${dataHome}/gradle";
        LESSHISTFILE = "${stateHome}/less/history";
        NODE_REPL_HISTORY = "${dataHome}/node_repl_history";
        NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
        NUGET_PACKAGES = "${cacheHome}/NuGetPackages";
        PASSWORD_STORE_DIR = "${dataHome}/password-store";
        PNPM_HOME = "${dataHome}/pnpm";
        PYTHONPYCACHEPREFIX = "${cacheHome}/python";
        PYTHONUSERBASE = "${dataHome}/python";
        RUSTUP_HOME = "${dataHome}/rustup";
        W3M_DIR = "${stateHome}/w3m";
        WEGORC = "${configHome}/wego/wegorc";
        WGETRC = "${configHome}/wgetrc";
        WINEPREFIX = "${dataHome}/wineprefixes/default";
        XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
      };
    in
    {
      home.username = "skarphet";
      home.homeDirectory = "/home/skarphet";

      home.sessionPath = additionalPaths;
      home.sessionVariables = allSessionVars;
      systemd.user.sessionVariables = allSessionVars // {
        PATH = "${lib.concatStringsSep ":" additionalPaths}:$PATH";
      };
      xdg.configFile."user-env.json".text = builtins.toJSON env;

      xdg.userDirs = {
        enable = true;
        createDirectories = false;
        setSessionVariables = false;

        desktop = "${homeDir}/desk";
        documents = "${homeDir}/doc";
        download = "${homeDir}/dl";
        music = "${homeDir}/mp3";
        pictures = "${homeDir}/img";
        publicShare = "${homeDir}/pub";
        templates = homeDir;
        videos = "${homeDir}/vid";
        projects = homeDir;
      };

      dconf.enable = true;
    };
  # }}}
}

# -- vim: fdm=marker fdl=0
