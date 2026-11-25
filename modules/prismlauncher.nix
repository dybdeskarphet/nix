{ ... }:
{
  home.gui =
    {
      pkgs,
      config,
      sandbox,
      ...
    }:
    let
      prismPkg = pkgs.prismlauncher.override {
        jdks = with pkgs; [
          temurin-bin-25
          temurin-bin-21
          temurin-bin-17
          temurin-bin-8
        ];
      };

      sandboxedPrism = sandbox.wrap (
        { sloth, ... }:
        {
          imports = [ sandbox.gaming ];

          app.package = prismPkg;
          flatpak.appId = "org.prismlauncher.PrismLauncher";

          bubblewrap.bind.rw = [
            (sloth.mkdir "${config.xdg.dataHome}/PrismLauncher")
            (sloth.mkdir "${config.xdg.configHome}/PrismLauncher")
            config.xdg.userDirs.download
          ];
        }
      );
    in
    {
      home.packages = [ sandboxedPrism ];
    };
}
