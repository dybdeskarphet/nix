{ pkgs, lib, ... }:
let
  inherit (import ../../lib/sandbox.nix { inherit lib; }) mkSandboxed;
in
{
  mkSandboxed = args: mkSandboxed (args // { inherit pkgs; });
}
