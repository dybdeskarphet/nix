{ pkgs, ... }:
let
  myFonts = pkgs.runCommand "my-fonts" { } ''
    mkdir -p $out/share/fonts/truetype
    cp ${./fonts}/*.ttf $out/share/fonts/truetype/
  '';
in
{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      inter
      roboto
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      myFonts
    ];
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.style = "slight";
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
        sansSerif = [ "Inter" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="pattern">
            <test name="family" qual="any">
              <string>monospace_font</string>
            </test>
            <edit binding="strong" mode="prepend" name="family">
              <string>JetBrainsMono Nerd Font Mono</string>
            </edit>
          </match>

          <match target="pattern">
            <test name="family" qual="any">
              <string>monospace_alt_font</string>
            </test>
            <edit binding="strong" mode="prepend" name="family">
              <string>JetBrainsMono Nerd Font Propo</string>
            </edit>
          </match>

          <match target="pattern">
            <test name="family" qual="any">
              <string>proportional_font</string>
            </test>
            <edit binding="strong" mode="prepend" name="family">
              <string>Mulish</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };
}
