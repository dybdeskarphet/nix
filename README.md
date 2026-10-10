# Nix

Personal **NixOS** configuration managed with Flakes and Home Manager.

## Stack

- [Niri](https://github.com/YaLTeR/niri) (Waybar, Mako, Avizo, Kanshi)
- [Matugen](https://github.com/InioX/matugen) (Material You dynamic colors from wallpaper)
- [Foot](https://codeberg.org/dnkl/foot) + [Fish](https://fishshell.com)
- Neovim ([dybdeskarphet/neovim-config](https://github.com/dybdeskarphet/neovim-config))
- [Yazi](https://github.com/sxyazi/yazi)
- Zotero, LibreOffice, Pandoc, Rnote, Zathura
- Bubblewrap application sandboxing, Hyprlock

## Architecture & Secrets

- Split according to human context: `desktop`, `dev`, `academic`, `security`, `backup`, and `utility`.
- Personal identifiers, signing keys, and paths are kept in `env.nix` and overridden locally via `/etc/nixos/env.nix`.

## Usage

Rebuild and switch using `nh` (don't forget to configure your `/etc/nixos/env.nix`):

```bash
# apply
nh os switch .

# test
nh os test .
```
