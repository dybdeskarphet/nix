#!/usr/bin/env python3
"""
Event-driven Battery & Bluetooth Monitor Daemon.
Subscribes to UPower and BlueZ D-Bus signals (zero polling).
"""

import subprocess
from gi.repository import GLib
from pydbus import SystemBus

PC_REPLACE_ID = 87873
BT_REPLACE_ID = 87874

last_pc_tier = None
last_bt_tiers: dict[str, str] = {}


def notify(app: str, title: str, message: str, icon: str, urgency: str = "normal", replace_id: int = 0) -> None:
    cmd = [
        "notify-send",
        "-a", app,
        "-i", icon,
        "-t", "10000",
        f"--urgency={urgency}",
    ]
    if replace_id > 0:
        cmd.append(f"--replace-id={replace_id}")
    cmd.extend([title, message])
    subprocess.run(cmd, check=False)


def handle_pc_battery(percentage: float, state: int) -> None:
    """
    UPower State: 1 = Charging, 2 = Discharging, 4 = Fully Charged
    """
    global last_pc_tier

    if state in (1, 4):
        last_pc_tier = None
        return

    if state != 2:
        return

    pct = int(percentage)

    if pct < 2 and last_pc_tier != "danger":
        last_pc_tier = "danger"
        notify("ACPI", f"battery {pct}%", "device is about to shut down!", "battery-010", "critical", PC_REPLACE_ID)
        # Dim brightness and play alert sound
        subprocess.run(["brightnessctl", "set", "20%"], check=False)
        subprocess.Popen(
            ["canberra-gtk-play", "-i", "dialog-warning"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

    elif pct <= 5 and last_pc_tier not in ("danger", "critical"):
        last_pc_tier = "critical"
        notify("ACPI", f"battery {pct}%", "device may shut down in a few minutes.", "battery-010", "critical", PC_REPLACE_ID)

    elif pct < 15 and last_pc_tier is None:
        last_pc_tier = "warn"
        notify("ACPI", f"battery {pct}%", "plug in your device!", "battery-010", "normal", PC_REPLACE_ID)

    elif pct >= 15:
        last_pc_tier = None


def handle_bt_battery(device_name: str, percentage: float) -> None:
    global last_bt_tiers
    pct = int(percentage)
    current_tier = last_bt_tiers.get(device_name)

    if pct <= 10 and current_tier != "critical":
        last_bt_tiers[device_name] = "critical"
        notify("Bluetooth", f"{device_name} battery low ({pct}%)", "the device may shut down in a few minutes.", "battery-010", "critical", BT_REPLACE_ID)

    elif pct < 20 and current_tier is None:
        last_bt_tiers[device_name] = "warn"
        notify("Bluetooth", f"{device_name} battery ({pct}%)", "it is recommended to plug in your device.", "battery-010", "normal", BT_REPLACE_ID)

    elif pct >= 20:
        last_bt_tiers.pop(device_name, None)


def on_properties_changed(sender, object_path, interface_name, signal_name, params):
    iface, changed_props, _ = params

    # 1. Handle UPower Devices (Laptop BAT0 and UPower-managed peripherals)
    if iface == "org.freedesktop.UPower.Device":
        bus = SystemBus()
        try:
            dev = bus.get("org.freedesktop.UPower", object_path)
            dev_type = getattr(dev, "Type", 0)
            percentage = getattr(dev, "Percentage", 100.0)
            state = getattr(dev, "State", 0)
            model = getattr(dev, "Model", "") or getattr(dev, "NativePath", "Bluetooth Device")

            if dev_type == 2:  # Type 2 = Laptop Battery
                handle_pc_battery(percentage, state)
            elif dev_type in (5, 6, 7, 8, 20):  # Peripherals (Mouse, Keyboard, Headset, etc.)
                handle_bt_battery(model, percentage)
        except Exception:
            pass

    # 2. Handle BlueZ Direct Battery signals (if device reports via BlueZ GATT)
    elif iface == "org.bluez.Battery1":
        if "Percentage" in changed_props:
            pct = changed_props["Percentage"]
            bus = SystemBus()
            try:
                dev = bus.get("org.bluez", object_path)
                name = getattr(dev, "Name", getattr(dev, "Alias", "Bluetooth Device"))
            except Exception:
                name = "Bluetooth Device"
            handle_bt_battery(name, pct)


def main():
    bus = SystemBus()

    # Subscribe to D-Bus property changes on the system bus
    bus.con.signal_subscribe(
        None,
        "org.freedesktop.DBus.Properties",
        "PropertiesChanged",
        None,
        None,
        0,
        on_properties_changed,
    )

    # GLib event loop blocks until a signal is received
    loop = GLib.MainLoop()
    loop.run()


if __name__ == "__main__":
    main()
