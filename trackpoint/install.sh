#!/usr/bin/env bash
# Install the TrackPoint scroll daemon as a system service. Re-runnable.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
python3 -c 'import evdev' 2>/dev/null || { echo "Installing python-evdev"; sudo pacman -S --needed --noconfirm python-evdev; }
sudo install -m 755 "$here/trackpoint-scroll.py" /usr/local/bin/trackpoint-scroll.py
sudo install -m 644 "$here/trackpoint-scroll.service" /etc/systemd/system/trackpoint-scroll.service
sudo systemctl daemon-reload
sudo systemctl enable --now trackpoint-scroll.service
sleep 1
systemctl --no-pager --lines=3 status trackpoint-scroll.service || true
echo "Push the nub: it should scroll, not move the pointer. Undo: sudo systemctl disable --now trackpoint-scroll.service"
