{
  description = "NixOS Bare Metal Transition Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-vm.nix
        ];
      };
      apps.${system}.build-vm = {
        type = "app";
        program = "${pkgs.writeShellScript "build-vm" ''
          nix build .#nixosConfigurations.nixos.config.system.build.vm "$@"
        ''}";
      };
    };
}
