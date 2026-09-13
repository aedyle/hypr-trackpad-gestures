#!/usr/bin/env python3
"""Report how many fingers each touchpad can track. Run with sudo."""
import array, fcntl, glob, re
ABS_MT_SLOT = 0x2F
def absinfo(fd, code):
    buf = array.array("i", [0] * 6)
    fcntl.ioctl(fd, (2 << 30) | (24 << 16) | (ord("E") << 8) | (0x40 + code), buf, True)
    return buf
found = False
for dev in sorted(glob.glob("/sys/class/input/event*/device/name")):
    name = open(dev).read().strip()
    if not re.search(r"touchpad|trackpad|clickpad", name, re.I):
        continue
    found = True
    node = "/dev/input/" + dev.split("/")[4]
    try:
        with open(node, "rb") as fd:
            slots = absinfo(fd, ABS_MT_SLOT)
            x, y = absinfo(fd, 0x35), absinfo(fd, 0x36)
    except OSError as e:
        print(f"{name} ({node}): cannot read, {e}. Run with sudo.")
        continue
    fingers = slots[2] + 1
    mm = lambda a: f"{(a[2]-a[1]) / a[5]:.0f} mm" if a[5] else "unknown size"
    verdict = "OK for 3- and 4-finger gestures" if fingers >= 4 else "too few contacts for 4-finger gestures"
    print(f"{name} ({node}): tracks {fingers} fingers, {mm(x)} x {mm(y)}. {verdict}.")
if not found:
    print("No touchpad found among input devices.")
