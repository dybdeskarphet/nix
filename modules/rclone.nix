{ ... }:
{
  nixos.rclone =
    { ... }:
    {
      programs.fuse.userAllowOther = true;
    };

  home.rclone =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        rclone
        fuse3
      ];
    };
}
