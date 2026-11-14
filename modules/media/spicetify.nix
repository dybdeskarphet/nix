{
  pkgs,
  inputs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.text;

    # Monokai Pro Spectrum (matches modules/dev/foot/default.nix)
    customColorScheme = {
      accent = "7bd88f";
      accent-active = "8ce19e";
      accent-inactive = "191919";
      banner = "8ce19e";
      border-active = "8ce19e";
      border-inactive = "676767";
      header = "676767";
      highlight = "222222";
      main = "191919";
      notification = "6fa5eb";
      notification-error = "fc618d";
      subtext = "d4d4d4";
      text = "f4f4f4";
    };
  };
}
