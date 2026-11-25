{ inputs, ... }:
{
  nixos.base = {
    sops = {
      defaultSopsFile = "${inputs.private}/secrets.yaml";
      age.keyFile = "/root/.config/sops/age/keys.txt";
    };
  };
}
