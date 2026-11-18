{ ... }:
{
  # NixOS User & Login {{{
  nixos.base =
    { pkgs, config, ... }:
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
        packages = [ ];
        shell = pkgs.fish;
        initialPassword = "nixos";
      };
      users.users.root.initialPassword = "nixos";

      services.getty = {
        loginOptions = "-p -- skarphet";
        extraArgs = [
          "--skip-login"
          "--noclear"
          "--issue-file"
          "${config.users.users.skarphet.home}/.config/matugen/references/issue"
        ];
      };
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
      generalVars = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      xdgVars = {
        ADB_KEYS_PATH = "${config.xdg.dataHome}/android";
        GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
        LESSHISTFILE = "${config.xdg.stateHome}/less/history";
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
        WEGORC = "${config.xdg.configHome}/wego/wegorc";
      };

      waylandVars = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        GDK_BACKEND = "wayland";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";
      };

      additionalPaths = [
        "${config.home.homeDirectory}/.local/bin"
        "${config.home.homeDirectory}/code/system"
      ];

      allSessionVars = xdgVars // waylandVars // generalVars;
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

      dconf.enable = true;
    };
  # }}}
}

# -- vim: fdm=marker fdl=0
