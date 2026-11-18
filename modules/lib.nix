{ inputs, ... }:
let
  helpers = import ../lib { lib = inputs.nixpkgs.lib; };
in
{
  _module.args.helpers = helpers;
}

# -- vim: fdm=marker fdl=0
