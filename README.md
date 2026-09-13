# hypr-trackpad-gestures

macOS-style trackpad gestures for [Omarchy](https://omarchy.org/) (Hyprland 0.55+ with the Lua config). No daemons, no plugins. Two lines of native Hyprland config, plus a script to check your trackpad first.

| Gesture | What it does |
|---|---|
| Three-finger swipe, any direction | Moves the active window around the screen, 1:1 with your fingers |
| Four-finger swipe left or right | Switches workspaces, with the live slide animation |
| Super held + three-finger swipe | Resizes the active window, width and height following your fingers independently |

Extras (two-finger pinch zoom, three-finger fullscreen/close, four-finger pinch to open the launcher) are in `gestures.lua`, commented out.

## Will it work on my laptop?

The trackpad needs to report at least four simultaneous contacts. Most Synaptics, Elan and Apple-style pads from the last decade do. Check:

```bash
sudo ./check-touchpad.py
```

Example output from a ThinkPad E14 Gen 6:

```
SYNA8020:00 06CB:CE5C Touchpad (/dev/input/event13): tracks 5 fingers, 112 mm x 53 mm. OK for 3- and 4-finger gestures.
```

If it says fewer than four fingers, the four-finger workspace swipe will not fire. Do not simply change it to three fingers: it would then overlap the three-finger window move, and Hyprland would fire whichever matched first. Use the three-finger fallback in `gestures.lua` instead. It gives workspaces to a plain three-finger sideways swipe and moves windows with Super held plus three fingers, which mirrors Super+drag. Resize moves to Super Shift plus three fingers.

## Install

```bash
git clone https://github.com/aedyle/hypr-trackpad-gestures.git
cd hypr-trackpad-gestures
./install.sh
```

The installer copies `gestures.lua` to `~/.config/hypr/`, adds `require("hypr.gestures")` to `~/.config/hypr/hyprland.lua` (backing it up first), reloads Hyprland and checks for config errors. It is safe to run again after editing `gestures.lua`.

Prefer to do it by hand? Paste the two `hl.gesture` lines into `~/.config/hypr/input.lua` and run `hyprctl reload`.

## Things to know

- **Leave three-finger drag off.** Hyprland's `input.touchpad.drag_3fg` must stay at its default of `0`. If it is on, libinput turns three-finger motion into a mouse drag before Hyprland can see it as a swipe, and the window-move gesture stops working.
- **Tiled versus floating.** On a tiled window the three-finger move drags the tile through the layout, like Super+drag. On a floating window it moves freely.
- **Why resize is a swipe, not a pinch.** libinput reports a pinch as one scale number plus rotation, never per-axis spread, so a pinch can only scale uniformly. A swipe reports x and y separately, which is what independent width and height need.
- **Two-finger swipes are scrolling.** libinput reserves them, so gestures start at three fingers. Two-finger pinch is fine.
- **Taps and edge swipes are not possible this way.** Hyprland only receives swipe and pinch events. For multi-finger taps or corner gestures you need a raw-evdev tool such as [edgepad](https://github.com/assembledev/edgepad) or [syngesture](https://github.com/mqudsi/syngesture).
- **Mission Control style overview** needs a Hyprland plugin. Active options in late 2026: [sandwichfarm/hyprexpo](https://github.com/sandwichfarm/hyprexpo), [hymission](https://github.com/gfhdhytghd/hymission), [hyprview](https://github.com/yz778/hyprview). All bind to a four-finger swipe up through the same `hl.gesture` mechanism.

## Undo

```bash
rm ~/.config/hypr/gestures.lua
```

Then remove the `require("hypr.gestures")` line from `~/.config/hypr/hyprland.lua` and run `hyprctl reload`.

## Reference

Full gesture syntax, directions, actions and live-gesture callbacks: <https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/>

Tested on Omarchy 4.0.2, Hyprland 0.56.2, libinput 1.31, ThinkPad E14 Gen 6 (Synaptics SYNA8020 clickpad), September 2026.
