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
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
    ];
    package = pkgs.ungoogled-chromium.override {
      enableWideVine = true;
    };
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
