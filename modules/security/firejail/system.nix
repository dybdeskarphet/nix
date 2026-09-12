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
    { obs = "obs-studio"; }
  ];

  mkWrappedEntry =
    item:
    if builtins.isString item then
      {
        name = item;
        value = {
          executable = "${lib.getExe pkgs.${item}}";
          profile = "${pkgs.firejail}/etc/firejail/${item}.profile";
        };
      }
    else
      let
        binary = builtins.head (builtins.attrNames item);
        target = item.${binary};
        pkg = if builtins.isString target then pkgs.${target} else target;
      in
      {
        name = binary;
        value = {
          executable = "${lib.getExe pkg}";
          profile = "${pkgs.firejail}/etc/firejail/${binary}.profile";
        };
      };
in
{
  programs.firejail = {
    enable = true;

    wrappedBinaries = builtins.listToAttrs (map mkWrappedEntry firejailedApps);
  };
}
