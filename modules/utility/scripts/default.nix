{ pkgs, ... }:
let
  userScripts = pkgs.stdenv.mkDerivation {
    name = "user-scripts";
    src = ./.;

    nativeBuildInputs = with pkgs; [
      python3
      fish
    ];

    installPhase = ''
      mkdir -p $out/bin
      for f in *; do
        if [ -f "$f" ] && [ "$f" != "default.nix" ]; then
          install -Dm755 "$f" "$out/bin/$f"
        fi
      done
    '';
  };
in
{
  home.packages = with pkgs; [
    jq
    nmap
    qrencode
    rofi
    (tesseract.override {
      enableLanguages = [
        "eng"
        "tur"
      ];
    })
    userScripts
  ];
}
