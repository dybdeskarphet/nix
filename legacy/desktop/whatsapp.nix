{ pkgs, lib, ... }:
let
  pname = "elecwhat";
  version = "1.14.0";

  src = pkgs.fetchurl {
    url = "https://github.com/piec/elecwhat/releases/download/v${version}/elecwhat-${version}.AppImage";
    hash = "sha512-2Rf7OmKbYGjxQ0RKeJgZ0qOPdiUsidqoWEXCgr8FFLawiO+98ltANes+UFVJYRijmdoecCqF5d3XSno2+MwpHg==";
  };

  whatsapp = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs: [ pkgs.libnotify ];

    extraInstallCommands = ''
      ln -s ${pname} $out/bin/whatsapp
    '';

    meta = with lib; {
      description = "Simple desktop WhatsApp client for Linux";
      homepage = "https://github.com/piec/elecwhat";
      license = licenses.gpl3Only;
      platforms = [ "x86_64-linux" ];
      mainProgram = "whatsapp";
    };
  };
in
{
  home.packages = [ whatsapp ];
}
