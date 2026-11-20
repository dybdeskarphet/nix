{ ... }:
{
  nixos.services =
    { ... }:
    {
      programs.fuse.userAllowOther = true;
    };

  home.services =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        rclone
        fuse3
      ];
    };
}
