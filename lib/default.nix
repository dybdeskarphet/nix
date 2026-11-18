{ lib }:
{
  colors = import ./colors.nix { inherit lib; };
  sandbox = import ./sandbox.nix { inherit lib; };
}
