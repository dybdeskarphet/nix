{ inputs, ... }:
{
  home.base =
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
    {
      _module.args = {
        mkNixPak = inputs.nixpak.lib.nixpak {
          inherit lib pkgs;
        };

        nixpakGuiBase =
          { sloth, ... }:
          {
            imports = [ inputs.nixpak.nixpakModules.gui-base ];

            gpu.provider = lib.mkForce "nixos";
            timeZone.enable = true;
            fonts.fonts = osConfig.fonts.packages ++ [ pkgs.adwaita-fonts ];

            bubblewrap = {
              dieWithParent = true;
              newSession = true;
              tmpfs = [ "/tmp" ];
              bind = {
                ro = [
                  "/etc/passwd"
                  "/etc/group"
                ];
                rw = lib.mkBefore [
                  [
                    (sloth.mkdir sloth.appCacheDir)
                    sloth.xdgCacheHome
                  ]
                ];
              };
              env.XDG_DATA_DIRS = lib.mkForce (
                lib.makeSearchPath "share" [
                  pkgs.adw-gtk3
                  pkgs.papirus-icon-theme
                  pkgs.adwaita-icon-theme
                  pkgs.hicolor-icon-theme
                  pkgs.shared-mime-info
                ]
              );
            };
          };
      };
    };
}
