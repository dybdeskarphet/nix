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
    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin lite
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
      { id = "jplgfhpmjnbigmhklmmbgecoobifkmpa"; } # proton vpn
      { id = "oocalimimngaihdkbihfgmpkcpnmlaoa"; } # teleparty
      { id = "ekhagklcjbdpajgpjgmbionohlpdbjgc"; } # zotero connector
      { id = "oboonakemofpalcgghocfoadofidjkkk"; } # keepassxc
      { id = "lpgajkhkagnpdjklmpgjeplmgffnhhjj"; } # trim
      { id = "jinjaccalgkegednnccohejagnlnfdag"; } # violentmonkey
      { id = "mmioliijnhnoblpgimnlajmefafdfilb"; } # shazam
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
