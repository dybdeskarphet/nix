{ pkgs, ... }: {
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
}
