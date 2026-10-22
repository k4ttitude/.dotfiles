-- Personal keybindings, loaded after Omarchy's defaults.
-- o.rebind removes Omarchy's binding on the same keys first; Hyprland would
-- otherwise run both.
-- See every binding: omarchy menu keybindings --print (or SUPER + SHIFT + /)

-- vicinae; the apps launcher it replaces gets the Omarchy menu
o.rebind("SUPER + SPACE", "Vicinae", "vicinae toggle")
o.bind("ALT + SPACE", "Vicinae", "vicinae toggle")
o.rebind("SUPER + ALT + SPACE", "Omarchy menu", { menu = "root" })

-- hjkl focus; Omarchy's J/K/L actions move elsewhere
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.rebind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.rebind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.rebind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

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
o.rebind("SUPER + SHIFT + SLASH", "Keybindings", "omarchy-menu-keybindings")

-- file manager
o.bind("SUPER + E", "File manager", { omarchy = "nautilus" })
