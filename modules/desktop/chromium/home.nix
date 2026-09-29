{ pkgs, lib, ... }:
let
  webApps = {
    google-meet = {
      name = "Google Meet";
      url = "https://meet.google.com";
      icon = "google-meet";
    };
  };
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium.override {
      enableWideVine = true;
    };

    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--extension-mime-request-handling=always-prompt-for-install"
    ];

    extensions = [
      {
        id = "ocaahhhbfnlfpeeiejnhhibimdbmnfdh";
        version = "1.5.5.4";
        crxPath = pkgs.fetchurl {
          url = "https://github.com/NeverDecaf/chromium-web-store/releases/download/v1.5.5.4/Chromium.Web.Store.crx";
          hash = "sha256-Y8B1tKJbEa8sU22tGRlG6NlUf5LVtsJXss5BONKZbzI=";
        };
      }
    ];
  };

  home.packages = lib.mapAttrsToList (
    bin: app:
    pkgs.writeShellScriptBin bin ''
      exec chromium --profile-directory=Default --app="${app.url}" "$@"
    ''
  ) webApps;

  xdg.desktopEntries = builtins.mapAttrs (bin: app: {
    name = app.name;
    exec = bin;
    icon = app.icon or "chromium";
    terminal = false;
    type = "Application";
    categories = [
      "Network"
      "Application"
    ];
  }) webApps;
}
