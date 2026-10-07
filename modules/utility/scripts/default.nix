{ pkgs, lib, ... }:
let
  dirFiles = builtins.readDir ./.;

  toPackage =
    filename:
    let
      name = lib.strings.removeSuffix ".${lib.lists.last (lib.strings.splitString "." filename)}" filename;
      content = builtins.readFile (./. + "/${filename}");
    in
    if lib.hasSuffix ".py" filename then
      pkgs.writers.writePython3Bin name { } content
    else if lib.hasSuffix ".fish" filename then
      pkgs.writers.writeFishBin name content
    else if lib.hasSuffix ".sh" filename then
      pkgs.writeShellScriptBin name content
    else
      pkgs.writeScriptBin name content;

  scriptNames = builtins.filter (f: f != "default.nix" && dirFiles.${f} == "regular") (
    builtins.attrNames dirFiles
  );

  userScripts = map toPackage scriptNames;
in
{
  home.packages =
    with pkgs;
    [
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
    ]
    ++ userScripts;
}
