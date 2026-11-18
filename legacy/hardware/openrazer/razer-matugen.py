import json
import os
import sys
from pathlib import Path

import openrazer.client


def get_color() -> tuple[int, int, int]:
    color_file = Path(os.path.expanduser("~/.config/openrazer/razer-colors.json"))
    if color_file.exists():
        try:
            data = json.loads(color_file.read_text())
            return data["r"], data["g"], data["b"]
        except Exception:
            pass
    return 255, 255, 255

def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "reactive"
    r, g, b = get_color()

    dm = openrazer.client.DeviceManager()
    for dev in dm.devices:
        try:
            if mode == "reactive":
                dev.fx.reactive(r, g, b, 0x01)
            elif mode == "static":
                dev.fx.static(r, g, b)
            elif mode == "breath":
                dev.fx.breath_single(r, g, b)
        except Exception as e:
            print(f"Failed to set effect on {dev.name}: {e}", file=sys.stderr)

if __name__ == "__main__":
    main()
