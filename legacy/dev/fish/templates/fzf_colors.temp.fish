set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
    --color=bg:-1,bg+:{{colors.surface_container_highest.default.hex}} \
    --color=fg:{{colors.on_surface.default.hex}},fg+:{{colors.on_surface.default.hex}} \
    --color=hl:{{colors.primary.default.hex}},hl+:{{colors.primary.default.hex}} \
    --color=info:{{colors.outline.default.hex}},prompt:{{colors.primary.default.hex}} \
    --color=pointer:{{colors.secondary.default.hex}},marker:{{colors.tertiary.default.hex}} \
    --color=spinner:{{colors.tertiary.default.hex}},header:{{colors.primary.default.hex}} \
    --color=border:{{colors.outline_variant.default.hex}}"
