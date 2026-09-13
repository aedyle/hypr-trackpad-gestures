-- Trackpad gestures for Hyprland (0.55+ Lua config) on Omarchy.
-- Load from ~/.config/hypr/hyprland.lua with:  require("hypr.gestures")
-- Wiki: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/

-- Three fingers: move the active window around the screen, any direction, 1:1.
-- Tiled windows drag through the layout; floating windows move freely.
hl.gesture({ fingers = 3, direction = "swipe", action = "move" })

-- Four fingers sideways: switch workspaces.
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- Super held + three fingers: resize the active window, each axis on its own.
-- Sideways finger travel changes width, vertical travel changes height, 1:1.
-- (A pinch can't do this: libinput reports a pinch as a single scale value.)
hl.gesture({ fingers = 3, direction = "swipe", mods = "SUPER", action = "resize" })

-- Four fingers up: fullscreen the active window. Four fingers down: leave fullscreen.
-- Explicit set/unset rather than the built-in toggle, so each direction always means one thing.
hl.gesture({ fingers = 4, direction = "up", action = function() hl.dispatch(hl.dsp.window.fullscreen({ action = "set", mode = "fullscreen" })) end })
hl.gesture({ fingers = 4, direction = "down", action = function() hl.dispatch(hl.dsp.window.fullscreen({ action = "unset" })) end })

-- Fallback for trackpads that only track three fingers (see check-touchpad.py).
-- Comment out the three-finger and four-finger gestures above and uncomment these. They must not
-- overlap: a plain three-finger swipe in any direction would swallow a
-- three-finger sideways swipe, so the window move takes a Super modifier.
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
-- hl.gesture({ fingers = 3, direction = "swipe", mods = "SUPER", action = "move" })
-- hl.gesture({ fingers = 3, direction = "swipe", mods = "SUPER SHIFT", action = "resize" })
-- hl.gesture({ fingers = 3, direction = "up", mods = "SUPER", action = function() hl.dispatch(hl.dsp.window.fullscreen({ action = "set", mode = "fullscreen" })) end })
-- hl.gesture({ fingers = 3, direction = "down", mods = "SUPER", action = function() hl.dispatch(hl.dsp.window.fullscreen({ action = "unset" })) end })

-- Optional extras. Uncomment what you want.
-- Two-finger pinch zooms the screen around the cursor, live.
-- hl.gesture({ fingers = 2, direction = "pinch", action = "cursor_zoom", zoom_level = 1, mode = "live" })
-- Three fingers down with Super held: close the active window.
-- hl.gesture({ fingers = 3, direction = "down", mods = "SUPER", action = "close" })
-- Four-finger pinch in: open the Omarchy launcher.
-- hl.gesture({ fingers = 4, direction = "pinchin", action = function() hl.exec_cmd("omarchy menu") end })
