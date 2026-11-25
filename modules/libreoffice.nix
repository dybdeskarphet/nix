{ ... }:
{
  home.gui =
    {
      pkgs,
      config,
      sandbox,
      ...
    }:
    let
      libreofficePak = sandbox.mk {
        config =
          { sloth, ... }:
          {
            imports = [ sandbox.offline ];

            app.package = pkgs.libreoffice;
            flatpak.appId = "org.libreoffice.LibreOffice";

            bubblewrap = {
              env.SAL_USE_VCLPLUGIN = "gtk3";
              bind.rw = [
                (sloth.mkdir "${config.xdg.configHome}/libreoffice")
                config.xdg.userDirs.documents
                config.xdg.userDirs.download
              ];
            };
          };
      };

      # Work around nixpak's config.env symlink rewriting breaking libreoffice's
      # absolute internal symlinks under bin/* -> $out/lib/libreoffice/program/*.
      sandboxedLibreoffice =
        pkgs.runCommand "nixpak-${pkgs.libreoffice.name}"
          {
            meta.mainProgram = "libreoffice";
          }
          ''
            mkdir -p $out/bin $out/share
            ln -s ${libreofficePak.config.script}/bin/libreoffice $out/bin/libreoffice
            ln -s ${libreofficePak.config.script}/bin/libreoffice $out/bin/soffice
            for pair in "swriter:writer" "scalc:calc" "simpress:impress" "sdraw:draw" "smath:math" "sbase:base"; do
              bin="''${pair%%:*}"
              flag="''${pair#*:}"
              cat > "$out/bin/$bin" <<EOF
            #!${pkgs.runtimeShell}
            exec "$out/bin/libreoffice" --$flag "\$@"
            EOF
              chmod +x "$out/bin/$bin"
            done

            for d in ${pkgs.libreoffice}/share/*; do
              name="$(basename "$d")"
              if [ "$name" = "applications" ]; then
                mkdir -p $out/share/applications
                for f in "$d"/*.desktop; do
                  sed 's/^\[Desktop Entry\]$/[Desktop Entry]\nX-Flatpak=org.libreoffice.LibreOffice/' "$f" > "$out/share/applications/$(basename "$f")"
                done
              else
                ln -s "$d" "$out/share/$name"
              fi
            done
          '';
    in
    {
      programs.libreoffice = {
        enable = true;
        package = sandboxedLibreoffice;
      };
    };
}
