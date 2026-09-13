{ pkgs, lib, ... }:
let
  c = r: g: b: a: [
    (r / 255.0)
    (g / 255.0)
    (b / 255.0)
    a
  ];
in
{
  home.packages = [ pkgs.rnote ];

  dconf.settings."com/github/flxzt/rnote" = {
    active-stroke-color = lib.hm.gvariant.mkTuple (c 249 245 215 1.0);
    active-fill-color = lib.hm.gvariant.mkTuple [
      0.0
      0.0
      0.0
      0.0
    ];

    colorpicker-color-1 = lib.hm.gvariant.mkTuple (c 29 32 33 1.0);
    colorpicker-color-2 = lib.hm.gvariant.mkTuple (c 249 245 215 1.0);
    colorpicker-color-3 = lib.hm.gvariant.mkTuple [
      0.0
      0.0
      0.0
      0.0
    ];
    colorpicker-color-4 = lib.hm.gvariant.mkTuple (c 211 134 155 1.0);
    colorpicker-color-5 = lib.hm.gvariant.mkTuple (c 131 165 152 1.0);
    colorpicker-color-6 = lib.hm.gvariant.mkTuple (c 142 192 124 1.0);
    colorpicker-color-7 = lib.hm.gvariant.mkTuple (c 250 189 47 1.0);
    colorpicker-color-8 = lib.hm.gvariant.mkTuple (c 254 128 25 1.0);
    colorpicker-color-9 = lib.hm.gvariant.mkTuple (c 251 73 52 1.0);

    document-config-preset = builtins.toJSON {
      layout = "fixed_size";
      background = {
        color = {
          r = 0.082;
          g = 0.075;
          b = 0.067;
          a = 1.0;
        };
        pattern = "grid";
        pattern_color = {
          r = 0.133;
          g = 0.122;
          b = 0.114;
          a = 1.0;
        };
        pattern_size = [
          27.0
          27.0
        ];
      };
      format = {
        dpi = 96.0;
        orientation = "portrait";
        width = 793.701;
        height = 1122.52;
        border_color = {
          r = 0.133;
          g = 0.122;
          b = 0.114;
          a = 1.0;
        };
        show_borders = true;
        show_origin_indicator = true;
      };
    };
  };
}
