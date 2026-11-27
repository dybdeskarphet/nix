#!/usr/bin/env python3
"""Event-driven Battery & Bluetooth monitor (UPower + BlueZ D-Bus)."""

import subprocess
from gi.repository import GLib
from pydbus import SystemBus

# UPower constants
UPOWER_CHARGING = 1
UPOWER_DISCHARGING = 2
UPOWER_FULL = 4
UPOWER_LAPTOP_BATTERY = 2
UPOWER_PERIPHERALS = {5, 6, 7, 8, 20}  # mouse, keyboard, headset, etc.

# (max_percent, urgency, message, dim_and_beep) — checked most severe first
PC_RULES = [
    (4, "critical", "device is about to hibernate!", True),
    (5, "critical", "device may shut down in a few minutes.", False),
    (15, "normal", "plug in your device!", False),
]

BT_RULES = [
    (10, "critical", "the device may shut down in a few minutes."),
    (20, "normal", "it is recommended to plug in your device."),
]

notified: dict[str, int] = {}  # device_key -> lowest threshold already alerted


def notify(app: str, title: str, body: str, urgency: str, replace_id: int) -> None:
    subprocess.run(
        [
            "notify-send",
            "-a", app,
            "-i", "battery-010",
            "-t", "10000",
            f"--urgency={urgency}",
            f"--replace-id={replace_id}",
            title,
            body,
        ],
        check=False,
    )


def check_pc(pct: int, state: int) -> None:
    if state in (UPOWER_CHARGING, UPOWER_FULL) or pct > PC_RULES[-1][0]:
        notified.pop("pc", None)
        return
    if state != UPOWER_DISCHARGING:
        return

    threshold, urgency, msg, dim_and_beep = next(r for r in PC_RULES if pct <= r[0])
    if threshold >= notified.get("pc", 101):
        return

    notified["pc"] = threshold
    notify("ACPI", f"battery {pct}%", msg, urgency, replace_id=87873)
    if dim_and_beep:
        subprocess.run(["brightnessctl", "set", "20%"], check=False)
        subprocess.Popen(
            ["canberra-gtk-play", "-i", "dialog-warning"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )


def check_bt(name: str, pct: int) -> None:
    if pct > BT_RULES[-1][0]:
        notified.pop(name, None)
        return

    threshold, urgency, msg = next(r for r in BT_RULES if pct <= r[0])
    if threshold >= notified.get(name, 101):
        return

    notified[name] = threshold
    notify("Bluetooth", f"{name} battery ({pct}%)", msg, urgency, replace_id=87874)


def main() -> None:
    bus = SystemBus()

    def on_upower(_conn, _sender, path, _iface, _sig, _params, *_user_data):
        try:
            dev = bus.get("org.freedesktop.UPower", path)
            dev_type = getattr(dev, "Type", 0)
            pct = int(getattr(dev, "Percentage", 100.0))
            if dev_type == UPOWER_LAPTOP_BATTERY:
                check_pc(pct, getattr(dev, "State", 0))
            elif dev_type in UPOWER_PERIPHERALS:
                name = getattr(dev, "Model", "") or getattr(dev, "NativePath", "Bluetooth Device")
                check_bt(name, pct)
        except Exception:
            pass

    def on_bluez(_conn, _sender, path, _iface, _sig, params, *_user_data):
        _, changed, _ = params
        if "Percentage" not in changed:
            return
        try:
            dev = bus.get("org.bluez", path)
            name = getattr(dev, "Name", None) or getattr(dev, "Alias", "Bluetooth Device")
            check_bt(name, int(changed["Percentage"]))
        except Exception:
            pass

    for sender, iface, handler in [
        ("org.freedesktop.UPower", "org.freedesktop.UPower.Device", on_upower),
        ("org.bluez", "org.bluez.Battery1", on_bluez),
    ]:
        bus.con.signal_subscribe(
            sender,
            "org.freedesktop.DBus.Properties",
            "PropertiesChanged",
            None,
            iface,
            0,
            handler,
        )

    GLib.MainLoop().run()


if __name__ == "__main__":
    main()
