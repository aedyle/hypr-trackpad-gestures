-- Trackpad gestures for Hyprland (0.55+ Lua config) on Omarchy.
-- Load from ~/.config/hypr/hyprland.lua with:  require("hypr.gestures")
-- Wiki: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/

-- Three fingers: move the active window around the screen, any direction, 1:1.
-- Tiled windows drag through the layout; floating windows move freely.
hl.gesture({ fingers = 3, direction = "swipe", action = "move" })

-- Four fingers sideways: switch workspaces, macOS style.
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- Optional extras. Uncomment what you want.
-- Two-finger pinch zooms the screen around the cursor, live.
-- hl.gesture({ fingers = 2, direction = "pinch", action = "cursor_zoom", zoom_level = 1, mode = "live" })
-- Three fingers up: fullscreen the active window. Three fingers down: close it.
-- hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
-- hl.gesture({ fingers = 3, direction = "down", mods = "SUPER", action = "close" })
-- Four-finger pinch in: open the Omarchy launcher.
-- hl.gesture({ fingers = 4, direction = "pinchin", action = function() hl.exec_cmd("omarchy menu") end })
