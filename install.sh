#!/usr/bin/env bash
# Copy gestures.lua into ~/.config/hypr and load it from hyprland.lua. Safe to re-run.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="$HOME/.config/hypr"
main="$dest/hyprland.lua"
[ -f "$main" ] || { echo "No $main found. Is this an Omarchy machine with Hyprland 0.55+?"; exit 1; }
if [ -f "$dest/gestures.lua" ] && ! cmp -s "$here/gestures.lua" "$dest/gestures.lua"; then
  cp "$dest/gestures.lua" "$dest/gestures.lua.bak.$(date +%s)"
  echo "Backed up existing gestures.lua"
fi
cp "$here/gestures.lua" "$dest/gestures.lua"
if ! grep -q 'require("hypr.gestures")' "$main"; then
  cp "$main" "$main.bak.$(date +%s)"
  printf '\n-- Trackpad gestures (see gestures.lua).\nrequire("hypr.gestures")\n' >> "$main"
  echo "Added require(\"hypr.gestures\") to hyprland.lua"
fi
hyprctl reload >/dev/null && echo "Hyprland reloaded"
errors="$(hyprctl configerrors)"
if [ -n "$errors" ]; then echo "Config errors:"; echo "$errors"; exit 1; fi
echo "Done. Try a three-finger swipe on a window and a four-finger swipe sideways."
