{ ... }:
{
  nixos.base =
    {
      pkgs,
      lib,
      colors,
      helpers,
      ...
    }:
    let
      normalColors = map helpers.colors.stripHash [
        colors.surface_container
        colors.error
        colors.primary
        colors.inverse_primary
        colors.primary
        colors.tertiary
        colors.secondary
        colors.on_surface
      ];

      brightColors = map helpers.colors.stripHash [
        colors.outline
        colors.error
        colors.primary
        colors.inverse_primary
        colors.primary
        colors.tertiary
        colors.secondary
        colors.on_surface
      ];

      loginProgram = pkgs.writeShellApplication {
        name = "agetty-login";
        bashOptions = [ ];
        runtimeInputs = [
          pkgs.coreutils
          pkgs.gnused
          pkgs.systemd
          pkgs.shadow
        ];
        text = builtins.readFile ./login.sh;
      };
    in
    {
      console = {
        earlySetup = true;
        packages = [ pkgs.terminus_font ];
        font = "ter-i20b";
        colors = normalColors ++ brightColors;
      };

      services.getty = {
        loginProgram = lib.getExe loginProgram;
        loginOptions = "-p -- skarphet";
        extraArgs = [
          "--skip-login"
          "--noissue"
          "--noclear"
        ];
      };
    };
}
