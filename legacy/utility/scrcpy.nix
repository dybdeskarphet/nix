{ pkgs, ... }:
{
  home.packages = [
    (pkgs.symlinkJoin {
      name = "scrcpy";
      paths = [ pkgs.scrcpy ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/scrcpy \
          --add-flags "--no-audio"
      '';
    })
    pkgs.android-tools
  ];
}
