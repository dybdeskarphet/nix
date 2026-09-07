{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  virtualisation = {
    diskSize = 20480;
  };
}
