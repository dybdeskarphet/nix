{ pkgs, lib, ... }:
let
  easyclone = pkgs.python313Packages.buildPythonApplication rec {
    pname = "easyclone";
    version = "1.3.0";
    pyproject = true;

    src = pkgs.python313Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-/w/x+FB1uxUoFMZNLgRYkjw1dRsVR7r3JgROtw8qpqk=";
    };

    build-system = with pkgs.python313Packages; [
      setuptools
      wheel
    ];

    dependencies = with pkgs.python313Packages; [
      pydantic
      toml
      typer
    ];

    makeWrapperArgs = [
      "--prefix PATH : ${lib.makeBinPath [ pkgs.rclone ]}"
    ];
  };
in
{
  imports = [
    ./config.nix
  ];

  home.packages = [ easyclone ];
}
