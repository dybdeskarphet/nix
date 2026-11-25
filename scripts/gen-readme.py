#!/usr/bin/env python3
"""Render README.md and SVG assets from templates with a given accent hex color."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEMPLATE_DIR = ROOT / "docs" / "readme"
ASSETS_DIR = ROOT / "assets"
README_TEMPLATE = TEMPLATE_DIR / "README.md.tpl"
README_OUT = ROOT / "README.md"

HEX_RE = re.compile(r"^#?[0-9a-fA-F]{6}$")


def normalize_hex(value: str) -> str:
    cleaned = value.strip()
    if not HEX_RE.match(cleaned):
        raise ValueError(f"Invalid hex color: {value!r}")
    return f"#{cleaned.lstrip('#').lower()}"


def generate(primary: str) -> list[Path]:
    ASSETS_DIR.mkdir(parents=True, exist_ok=True)
    written: list[Path] = []

    for tpl_path in sorted(TEMPLATE_DIR.glob("*.svg.tpl")):
        out_path = ASSETS_DIR / tpl_path.name.removesuffix(".tpl")
        out_path.write_text(
            tpl_path.read_text(encoding="utf-8").replace("{{primary}}", primary),
            encoding="utf-8",
        )
        written.append(out_path)

    README_OUT.write_text(
        README_TEMPLATE.read_text(encoding="utf-8").replace("{{primary}}", primary),
        encoding="utf-8",
    )
    written.append(README_OUT)
    return written


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate README.md and SVG assets with the given accent color."
    )
    parser.add_argument("color", help="Accent hex color (e.g. '#d4c5aa' or d4c5aa)")
    ns = parser.parse_args()

    try:
        primary = normalize_hex(ns.color)
        written = generate(primary)
    except Exception as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    print(f"Generated with primary={primary}:")
    for path in written:
        print(f"  - {path.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
