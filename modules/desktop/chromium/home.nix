{
  pkgs,
  pkgs-small,
  lib,
  ...
}:
let
  apps = import ./apps.nix;
in
{
  programs.chromium = {
    enable = true;
    package = pkgs-small.brave;

    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "jplgfhpmjnbigmhklmmbgecoobifkmpa"; } # Proton VPN
      { id = "oocalimimngaihdkbihfgmpkcpnmlaoa"; } # Teleparty
      { id = "ekhagklcjbdpajgpjgmbionohlpdbjgc"; } # Zotero Connector
      { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC-Browser
      { id = "lpgajkhkagnpdjklmpgjeplmgffnhhjj"; } # Trim
      { id = "jinjaccalgkegednnccohejagnlnfdag"; } # Violentmonkey
      { id = "mmioliijnhnoblpgimnlajmefafdfilb"; } # Shazam
      { id = "hlepfoohegkhhmjieoechaddaejaokhf"; } # Refined GitHub
      { id = "aobahdccfeoakodfnbgmkknokbmnndjm"; } # Tabliss
    ];

    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--gtk-version=4"
    ];
  };

  home.packages = map (
    app:
    pkgs.writeShellScriptBin app.bin ''
      desktop_file=$(grep -l -i "^Name=${app.name}$" ~/.local/share/applications/{chrome,brave}-*-Default.desktop 2>/dev/null | head -n 1)
      if [ -n "$desktop_file" ]; then
        exec $(sed -n 's/^Exec=//p' "$desktop_file") "$@"
      else
        exec brave --profile-directory=Default --app="${app.url}" "$@"
      fi
    ''
  ) apps;
}
