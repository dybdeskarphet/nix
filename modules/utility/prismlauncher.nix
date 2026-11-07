{ pkgs, ... }:
{
  home.packages = [
    (pkgs.prismlauncher.override {
      jdks = with pkgs; [
        temurin-bin-21
        temurin-bin-17
        temurin-bin-8
      ];
    })
  ];
}
