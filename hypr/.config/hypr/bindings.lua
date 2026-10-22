-- Personal keybindings, loaded after Omarchy's defaults.
-- rebind removes Omarchy's binding on the same keys first; Hyprland would
-- otherwise run both.
-- See every binding: omarchy menu keybindings --print (or SUPER + SHIFT + /)

local function rebind(keys, ...)
  hl.unbind(keys)
  o.bind(keys, ...)
end

-- vicinae; SUPER + SPACE stays the Omarchy menu
o.bind("ALT + SPACE", "Vicinae", "vicinae toggle")

-- hjkl focus; Omarchy's J/K/L actions move elsewhere
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
rebind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
rebind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
rebind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- hjkl swap, matching Omarchy's SUPER + SHIFT + arrows
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- layout
o.bind("SUPER + apostrophe", "Toggle window split", hl.dsp.layout("togglesplit"))
hl.unbind("SUPER + ALT + L")
o.bind("SUPER + semicolon", "Cycle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + ALT + semicolon", "Cycle workspace layout back", "omarchy-hyprland-workspace-layout-toggle back")

-- keybindings cheatsheet (replaces 1Password's binding)
rebind("SUPER + SHIFT + SLASH", "Keybindings", "omarchy-menu-keybindings")

-- file manager; SUPER + SHIFT + F goes to tiled full screen instead
o.bind("SUPER + E", "File manager", { omarchy = "nautilus" })
rebind("SUPER + SHIFT + F", "Tiled full screen", "omarchy-hyprland-window-tiled-fullscreen-toggle")

-- idle locking moves to SUPER + I; SUPER + CTRL + I switches input method
o.bind_toggle("SUPER + I", "Toggle locking on idle", "idle")
rebind("SUPER + CTRL + I", "Switch input method", "fcitx5-remote -t")
