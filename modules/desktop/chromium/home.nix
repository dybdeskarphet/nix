{ pkgs, lib, ... }:
let
  webApps = {
    google-meet = {
      name = "Google Meet";
      url = "https://meet.google.com";
      icon = "google-meet";
    };
  };
  chromiumWebStore = pkgs.fetchFromGitHub {
    owner = "NeverDecaf";
    repo = "chromium-web-store";
    rev = "v1.5.5.4";
    hash = "sha256-Hsk3bh4AYWCYyK8JJjWV1gcdQTrdzTODQithRHeCzu8=";
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
      "--load-extension=${chromiumWebStore}/src"
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
