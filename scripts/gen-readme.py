#!/usr/bin/env python3
"""Render README.md and themed SVG assets from templates using current Nix colors."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEMPLATE_DIR = ROOT / "docs" / "readme"
ASSETS_DIR = ROOT / "assets"
README_TEMPLATE = TEMPLATE_DIR / "README.md.tpl"
README_OUT = ROOT / "README.md"

HEX_RE = re.compile(r"^#?[0-9a-fA-F]{6}$")
NIX_COLORS_ATTR = (
    ".#nixosConfigurations.nixos.config.home-manager.extraSpecialArgs.colors"
)


def normalize_hex(value: str, name: str) -> str:
    cleaned = value.strip()
    if not HEX_RE.match(cleaned):
        raise ValueError(f"Invalid hex color for {name}: {value!r}")
    return f"#{cleaned.lstrip('#').lower()}"


def parse_colors_payload(data: dict) -> dict[str, str]:
    raw = data.get("colors", data)
    parsed: dict[str, str] = {}
    for key, val in raw.items():
        if isinstance(val, dict):
            val = val.get("dark", {}).get("color")
        if isinstance(val, str) and HEX_RE.match(val.strip()):
            parsed[key] = normalize_hex(val, key)
    return parsed


def load_colors_from_nix() -> dict[str, str] | None:
    cmd = [
        "nix",
        "eval",
        "--extra-experimental-features",
        "nix-command flakes",
        "--impure",
        "--json",
        NIX_COLORS_ATTR,
    ]
    proc = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
    if proc.returncode != 0:
        return None
    return parse_colors_payload(json.loads(proc.stdout))


def load_colors_from_swayimg() -> dict[str, str] | None:
    init_lua = Path.home() / ".config" / "swayimg" / "init.lua"
    if not init_lua.is_file():
        return None
    text = init_lua.read_text(encoding="utf-8")
    parsed: dict[str, str] = {}
    for match in re.finditer(r'(\w+)\s*=\s*"(#[0-9a-fA-F]{6})"', text):
        parsed[match.group(1)] = match.group(2).lower()
    if "primary" in parsed and "background" in parsed:
        return parsed
    return None


def resolve_colors(args: argparse.Namespace) -> dict[str, str]:
    colors: dict[str, str] = {}
    if args.colors_json:
        payload = json.loads(Path(args.colors_json).read_text(encoding="utf-8"))
        colors = parse_colors_payload(payload)
    elif not (args.primary and args.background):
        colors = load_colors_from_nix() or load_colors_from_swayimg() or {}

    if args.primary:
        colors["primary"] = normalize_hex(args.primary, "primary")
    if args.background:
        colors["background"] = normalize_hex(args.background, "background")

    missing = [k for k in ("primary", "background") if k not in colors]
    if missing:
        raise RuntimeError(
            f"Could not determine {', '.join(missing)} from nix eval or ~/.config/swayimg/init.lua. "
            "Pass --primary and --background (or --colors-json) explicitly."
        )
    return colors


def build_tokens(colors: dict[str, str]) -> dict[str, str]:
    tokens = dict(colors)
    for key, val in colors.items():
        tokens[f"{key}_hex"] = val.lstrip("#")
    return tokens


def render_text(template: str, tokens: dict[str, str]) -> str:
    def replace(match: re.Match[str]) -> str:
        key = match.group(1)
        if key not in tokens:
            raise KeyError(f"Missing color token {{{{{key}}}}}")
        return tokens[key]

    return re.sub(r"\{\{(\w+)\}\}", replace, template)


def generate(tokens: dict[str, str]) -> list[Path]:
    ASSETS_DIR.mkdir(parents=True, exist_ok=True)
    written: list[Path] = []

    for tpl_path in sorted(TEMPLATE_DIR.glob("*.svg.tpl")):
        out_path = ASSETS_DIR / tpl_path.name.removesuffix(".tpl")
        out_path.write_text(
            render_text(tpl_path.read_text(encoding="utf-8"), tokens), encoding="utf-8"
        )
        written.append(out_path)

    readme_text = render_text(README_TEMPLATE.read_text(encoding="utf-8"), tokens)
    README_OUT.write_text(readme_text, encoding="utf-8")
    written.append(README_OUT)
    return written


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate themed README.md and SVG assets."
    )
    parser.add_argument("--primary", help="Override primary hex color (e.g. #89b4fa)")
    parser.add_argument(
        "--background", help="Override background hex color (e.g. #1e1e2e)"
    )
    parser.add_argument("--colors-json", help="Read colors from a JSON file")
    ns = parser.parse_args()

    try:
        colors = resolve_colors(ns)
        written = generate(build_tokens(colors))
    except Exception as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    print(
        f"Generated with primary={colors['primary']} background={colors['background']}:"
    )
    for path in written:
        print(f"  - {path.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
