-- Trackpad gestures for Hyprland (0.55+ Lua config) on Omarchy.
-- Load from ~/.config/hypr/hyprland.lua with:  require("hypr.gestures")
-- Wiki: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/

-- Three fingers: move the active window around the screen, any direction, 1:1.
-- Tiled windows drag through the layout; floating windows move freely.
hl.gesture({ fingers = 3, direction = "swipe", action = "move" })

-- Four fingers sideways: switch workspaces, macOS style.
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- Super held + three fingers: resize the active window, each axis on its own.
-- Sideways finger travel changes width, vertical travel changes height, 1:1.
-- (A pinch can't do this: libinput reports a pinch as a single scale value.)
hl.gesture({ fingers = 3, direction = "swipe", mods = "SUPER", action = "resize" })

-- Fallback for trackpads that only track three fingers (see check-touchpad.py).
-- Comment out the three gestures above and uncomment these three. They must not
-- overlap: a plain three-finger swipe in any direction would swallow a
-- three-finger sideways swipe, so the window move takes a Super modifier.
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
-- hl.gesture({ fingers = 3, direction = "swipe", mods = "SUPER", action = "move" })
-- hl.gesture({ fingers = 3, direction = "swipe", mods = "SUPER SHIFT", action = "resize" })

-- Optional extras. Uncomment what you want.
-- Two-finger pinch zooms the screen around the cursor, live.
-- hl.gesture({ fingers = 2, direction = "pinch", action = "cursor_zoom", zoom_level = 1, mode = "live" })
-- Three fingers up: fullscreen the active window. Three fingers down: close it.
-- hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
-- hl.gesture({ fingers = 3, direction = "down", mods = "SUPER", action = "close" })
-- Four-finger pinch in: open the Omarchy launcher.
-- hl.gesture({ fingers = 4, direction = "pinchin", action = function() hl.exec_cmd("omarchy menu") end })
