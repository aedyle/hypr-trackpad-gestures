#!/usr/bin/env python3
"""Turn a ThinkPad TrackPoint into a scroll-only nub.

Grabs the TrackPoint exclusively so it no longer moves the pointer, and
re-emits its motion as scroll-wheel events through a virtual mouse. The
TrackPoint's own physical buttons are passed through unchanged, so the
button row above the touchpad keeps working as ordinary mouse buttons.

Runs as root (needs /dev/input and /dev/uinput). Stop the service to get
the pointer behaviour back; nothing is changed on disk.
"""
import os
import re
import sys
import time

import evdev
from evdev import InputDevice, UInput, ecodes as e

# Tuning. GAIN is hi-res wheel units per unit of nub motion; 120 = one notch.
GAIN = float(os.environ.get("TRACKPOINT_SCROLL_GAIN", "6"))
# Set NATURAL=1 to reverse the direction (push up scrolls the page down).
NATURAL = os.environ.get("TRACKPOINT_SCROLL_NATURAL", "0") == "1"
NAME_RE = re.compile(r"trackpoint|pointing stick|dualpoint stick", re.I)
BUTTONS = (e.BTN_LEFT, e.BTN_RIGHT, e.BTN_MIDDLE)
NOTCH = 120


def find_trackpoint():
    for path in evdev.list_devices():
        dev = InputDevice(path)
        if NAME_RE.search(dev.name) and e.EV_REL in dev.capabilities():
            return dev
        dev.close()
    return None


def make_virtual():
    caps = {
        e.EV_KEY: list(BUTTONS),
        # REL_X/REL_Y are declared but never sent, so udev classes this as a mouse.
        e.EV_REL: [e.REL_X, e.REL_Y, e.REL_WHEEL, e.REL_HWHEEL,
                   e.REL_WHEEL_HI_RES, e.REL_HWHEEL_HI_RES],
    }
    return UInput(caps, name="TrackPoint Scroll", vendor=0x17EF, product=0x6009, version=1)


def run(dev, ui):
    sign = 1 if NATURAL else -1
    acc_v = acc_h = 0.0  # hi-res units accumulated toward the next full notch
    for ev in dev.read_loop():
        if ev.type == e.EV_KEY and ev.code in BUTTONS:
            ui.write(e.EV_KEY, ev.code, ev.value)
        elif ev.type == e.EV_REL and ev.code == e.REL_Y and ev.value:
            hi = sign * ev.value * GAIN
            ui.write(e.EV_REL, e.REL_WHEEL_HI_RES, int(round(hi)))
            acc_v += hi
            notches = int(acc_v / NOTCH)
            if notches:
                ui.write(e.EV_REL, e.REL_WHEEL, notches)
                acc_v -= notches * NOTCH
        elif ev.type == e.EV_REL and ev.code == e.REL_X and ev.value:
            hi = ev.value * GAIN
            ui.write(e.EV_REL, e.REL_HWHEEL_HI_RES, int(round(hi)))
            acc_h += hi
            notches = int(acc_h / NOTCH)
            if notches:
                ui.write(e.EV_REL, e.REL_HWHEEL, notches)
                acc_h -= notches * NOTCH
        elif ev.type == e.EV_SYN:
            ui.syn()


def main():
    while True:
        dev = find_trackpoint()
        if dev is None:
            print("no TrackPoint found, retrying in 5s", flush=True)
            time.sleep(5)
            continue
        print(f"using {dev.name} at {dev.path}", flush=True)
        ui = None
        try:
            ui = make_virtual()
            dev.grab()
            run(dev, ui)
        except OSError as err:
            print(f"device error: {err}; reopening in 2s", flush=True)
            time.sleep(2)
        finally:
            try:
                dev.ungrab()
            except OSError:
                pass
            dev.close()
            if ui:
                ui.close()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(0)
