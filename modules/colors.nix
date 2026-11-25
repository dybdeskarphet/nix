{
  inputs,
  env,
  ...
}:
let
  pkgs = inputs.nixpkgs.legacyPackages.${env.system};

  wallpaperPath = env.wallpaper or null;
  wallpaperSrc =
    if wallpaperPath != null && wallpaperPath != "" then
      ../assets/wallpapers + "/${baseNameOf wallpaperPath}"
    else
      null;

  matugenCfg = pkgs.writeText "matugen-config.toml" ''
    [config]
    fallback_color = "#808080"

    [config.custom_colors]
    red = { color = "#ff0000", blend = true }
    green = { color = "#00ff00", blend = true }
    yellow = { color = "#ffcc00", blend = true }
    blue = { color = "#0000ff", blend = true }
    magenta = { color = "#ff00ff", blend = true }
    cyan = { color = "#00ffff", blend = true }

    [templates]
  '';

  matugenTarget =
    if wallpaperSrc != null then
      ''image "${wallpaperSrc}" --source-color-index 0 --include-image-in-json false''
    else
      ''color hex "#808080"'';

  generatedColorsJson = pkgs.runCommand "colors.json" { } ''
    run_matugen() {
      ${pkgs.lib.getExe pkgs.matugen} \
        ${matugenTarget} \
        -c "${matugenCfg}" \
        -m dark \
        -t "$1" \
        --dry-run \
        -j hex > "$out"
    }

    run_matugen scheme-neutral
    if [ "$(${pkgs.lib.getExe pkgs.jq} -r '.colors.source_color.dark.color' "$out")" = "#808080" ]; then
      run_matugen scheme-fidelity
    fi
  '';

  rawColors = builtins.fromJSON (builtins.readFile generatedColorsJson);

  colors = inputs.nixpkgs.lib.mapAttrs (_: v: v.dark.color) rawColors.colors;
in
{
  _module.args.colors = colors;
}
