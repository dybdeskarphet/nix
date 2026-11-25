{ ... }:
{
  home.x86_64 =
    {
      pkgs,
      lib,
      config,
      sandbox,
      ...
    }:
    let
      pname = "elecwhat";
      version = "1.16.2";

      src = pkgs.fetchurl {
        url = "https://github.com/piec/elecwhat/releases/download/v${version}/elecwhat-${version}.AppImage";
        hash = "sha512-+LW7WmnPOrjJqsg99WmJhuhBwNqSLtG2b1IJq3o9mc5ccOv8Ev8aBoaqobdc73lBMj4kB4IDCZ4/WvXc7JR4TA==";
      };

      extracted = pkgs.appimageTools.extract {
        inherit pname version src;
      };

      whatsappPkg =
        pkgs.runCommand "${pname}-${version}"
          {
            meta = with lib; {
              description = "Simple desktop WhatsApp client for Linux";
              homepage = "https://github.com/piec/elecwhat";
              license = licenses.gpl3Only;
              platforms = [ "x86_64-linux" ];
              mainProgram = "whatsapp";
            };
          }
          ''
            mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/512x512/apps
            cat > $out/bin/whatsapp <<EOF
            #!${pkgs.runtimeShell}
            exec ${lib.getExe pkgs.electron} --no-sandbox ${extracted}/resources/app.asar "\$@"
            EOF
            chmod +x $out/bin/whatsapp
            ln -s whatsapp $out/bin/elecwhat

            sed 's|^Exec=.*|Exec=whatsapp %U|' ${extracted}/elecwhat.desktop > $out/share/applications/elecwhat.desktop
            cp ${extracted}/usr/share/icons/hicolor/512x512/apps/elecwhat.png $out/share/icons/hicolor/512x512/apps/elecwhat.png
          '';

      sandboxedWhatsapp = sandbox.wrap (
        { sloth, ... }:
        {
          imports = [ sandbox.comms ];

          app = {
            package = whatsappPkg;
            extraEntrypoints = [ "/bin/elecwhat" ];
          };
          flatpak.appId = "io.github.piec.elecwhat";

          bubblewrap.bind.rw = [
            (sloth.mkdir "${config.xdg.configHome}/elecwhat")
            config.xdg.userDirs.download
            config.xdg.userDirs.pictures
          ];
        }
      );
    in
    {
      home.packages = [ sandboxedWhatsapp ];
    };
}
