{ lib }:
rec {
  stripHash = lib.removePrefix "#";

  hexToRgb =
    hex:
    let
      clean = stripHash hex;
    in
    {
      r = lib.fromHexString (builtins.substring 0 2 clean);
      g = lib.fromHexString (builtins.substring 2 2 clean);
      b = lib.fromHexString (builtins.substring 4 2 clean);
    };

  hexToRgba =
    alpha: hex:
    let
      rgb = hexToRgb hex;
    in
    "rgba(${toString rgb.r}, ${toString rgb.g}, ${toString rgb.b}, ${toString alpha})";

  toCssDefineColors =
    colors:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: hex: "@define-color ${name} ${hex};") colors
    );
}

# -- vim: fdm=marker fdl=0
