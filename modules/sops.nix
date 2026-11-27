{ inputs, ... }:
{
  nixos.sops = {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops = {
      defaultSopsFile = "${inputs.private}/secrets.yaml";
      age.keyFile = "/root/.config/sops/age/keys.txt";
    };
  };
}
