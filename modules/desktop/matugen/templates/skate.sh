#!/usr/bin/env sh
<* for name, value in colors *>
skate set {{ name }}@colors "{{ value.default.hex }}"
<* endfor *>

skate set primary_rgb@colors "{{ colors.primary.dark.rgb | auto_lightness: 40.0 }}"
skate set wallpaper@colors "{{ image }}"
