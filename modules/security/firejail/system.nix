{ lib, pkgs, ... }:
let
  firejailedApps = [
    "keepassxc"
    "chromium"
    "mpv"
    "zathura"
    "axel"
    "yt-dlp"
    "libreoffice"
    "ffmpeg"
    "obs"
  ];
in
{
  programs.firejail = {
    enable = true;

    wrappedBinaries = lib.genAttrs firejailedApps (name: {
      executable = "${lib.getExe pkgs.${name}}";
      profile = "${pkgs.firejail}/etc/firejail/${name}.profile";
    });
  };
}
