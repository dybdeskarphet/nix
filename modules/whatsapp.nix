{ ... }:
{
  home.gui =
    { pkgs, lib, ... }:
    let
      pname = "elecwhat";
      version = "1.16.2";

      src = pkgs.fetchurl {
        url = "https://github.com/piec/elecwhat/releases/download/v${version}/elecwhat-${version}.AppImage";
        hash = "sha512-+LW7WmnPOrjJqsg99WmJhuhBwNqSLtG2b1IJq3o9mc5ccOv8Ev8aBoaqobdc73lBMj4kB4IDCZ4/WvXc7JR4TA==";
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
    };
}
