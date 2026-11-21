{ ... }:
{
  nixos.gui =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraProfile = ''
            unset GDK_BACKEND SDL_VIDEODRIVER OZONE_PLATFORM CLUTTER_BACKEND
          '';
        };
      };
    };
}
