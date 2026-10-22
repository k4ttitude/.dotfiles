-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Personal overrides, loaded after Omarchy's defaults.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Omarchy already floats Steam and PiP and suppresses maximize events.

o.window("^mpv$", { float = true })
o.window("^(net.lutris.Lutris)$", { float = true })

-- steam
o.window({ initial_class = "^steam$" }, { no_initial_focus = true })
o.window("^steam$", { workspace = "4" })
-- steam games
local games = [[dota2|steam_app_\d+]]
o.window("^(" .. games .. ")$", { workspace = "3" })
o.window({ initial_class = "^(" .. games .. ")$" }, { workspace = "3" })

-- wwm
o.window({ title = "^Where Winds Meet$" }, { workspace = "3" })
o.window({ class = "^steam_app_3564740$", title = "^Where Winds Meet$" }, { workspace = "3", fullscreen = true })
o.window({ initial_title = "^wwm.exe$", initial_class = "^steam_app_default$" }, { workspace = "3", fullscreen = true })

-- poe2
o.window({ title = "^(Path of Exile 2)$" }, { workspace = "3" })

-- zen
o.window("^zen-alpha$", { size = { "monitor_w*0.5", "monitor_h*0.8" } })

-- vicinae
hl.layer_rule({
    name         = "vicinae-blur",
    match        = { namespace = "vicinae" },
    blur         = true,
    ignore_alpha = 0,
})
-- disable animation for vicinae only
hl.layer_rule({
    name    = "vicinae-no-animation",
    match   = { namespace = "vicinae" },
    no_anim = true,
})
