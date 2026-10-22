------------------
---- MONITORS ----
------------------

hl.monitor({
    output        = "",
    mode          = "2560x1440@280",
    position      = "0x0",
    scale         = 1,
    bitdepth      = 10,
    sdrbrightness = 1.38,
    sdrsaturation = 1.1,
})

hl.config({
    render = {
        cm_auto_hdr = 1,
    },
})

hl.env("WLR_USE_DAMAGE", "1")


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "nautilus"
local hyprHome    = os.getenv("HOME") .. "/.config/hypr"
local hyprBin     = hyprHome .. "/bin"
local menu        = hyprBin .. "/menu"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & hyprpaper")
    -- fcitx5 starts via /etc/xdg/autostart/org.fcitx.Fcitx5.desktop (uwsm/xdg-desktop-autostart)
    hl.exec_cmd("hyprswitch init --show-title &")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("swayosd-server")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("SDL_VIDEO_DRIVER", "x11")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

hl.env("GDK_BACKEND", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- hl.env("AMD_VULKAN_ICD", "RADV")

-- hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 6,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true, -- You probably want this
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        repeat_delay = 250,
        repeat_rate  = 40,

        follow_mouse = 0,

        sensitivity    = 0, -- -1.0 - 1.0, 0 means no modification.
        force_no_accel = false,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.device({
    name        = "realtek-mchose-a7-ultra(re)",
    sensitivity = -0.75,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Move submap: one hjkl press moves the window, then drops back to the global submap
hl.bind(mainMod .. " + M", hl.dsp.submap("move"))
hl.define_submap("move", "reset", function()
    hl.bind("l", hl.dsp.window.move({ direction = "right" }))
    hl.bind("h", hl.dsp.window.move({ direction = "left" }))
    hl.bind("j", hl.dsp.window.move({ direction = "down" }))
    hl.bind("k", hl.dsp.window.move({ direction = "up" }))
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("catchall", hl.dsp.submap("reset"))
end)

-- Resize submap: hjkl repeat until escape (or any other key)
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("l", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }), { repeating = true })
    hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0,   relative = true }), { repeating = true })
    hl.bind("j", hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })
    hl.bind("k", hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("catchall", hl.dsp.submap("reset"))
end)

-- Run submap
hl.bind(mainMod .. " + R", hl.dsp.submap("run"))
hl.define_submap("run", "reset", function()
    hl.bind("S", hl.dsp.exec_cmd(menu .. "/steam.sh"))
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("catchall", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + space",         hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("ALT + space",                 hl.dsp.exec_cmd("vicinae toggle"))
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.exec_cmd("wofi --show run"))
hl.bind(mainMod .. " + C",             hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",             hl.dsp.window.close())
hl.bind(mainMod .. " + CTRL + Q",      hl.dsp.exit())
hl.bind(mainMod .. " + E",             hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",             hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",             hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + F",             hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- toggle input methods
hl.bind(mainMod .. " + CTRL + I", hl.dsp.exec_cmd(hyprBin .. "/input.sh"))

-- screenshot
hl.bind(mainMod .. " + CTRL + SHIFT + 3", hl.dsp.exec_cmd("hyprshot -m window -m active -o ~/Pictures/Screenshots"))
hl.bind(mainMod .. " + CTRL + SHIFT + 4", hl.dsp.exec_cmd("hyprshot -m region --freeze -o ~/Pictures/Screenshots"))
hl.bind("Print",                          hl.dsp.exec_cmd("hyprshot -m active -m output --freeze -o ~/Pictures/Screenshots"))

-- volume (swayosd shows the OSD)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +5 --max-volume 100"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"),                   { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),          { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),           { locked = true })

-- recording
hl.bind(mainMod .. " + CTRL + 0",     hl.dsp.exec_cmd(hyprBin .. "/obs/start_recording"))
hl.bind(mainMod .. " + CTRL + minus", hl.dsp.exec_cmd(hyprBin .. "/obs/stop_recording"))

-- hyprswitch
local switchMod     = "alt"
local switchKey     = "tab"
local switchReverse = "grave"
local hyprswitchGui = "hyprswitch gui --mod-key " .. switchMod .. " --key " .. switchKey
    .. " --close mod-key-release --reverse-key=key=" .. switchReverse .. " --sort-recent"
hl.bind("ALT + " .. switchKey,                         hl.dsp.exec_cmd(hyprswitchGui .. " && hyprswitch dispatch"))
hl.bind("ALT + " .. switchReverse .. " + " .. switchKey, hl.dsp.exec_cmd(hyprswitchGui .. " && hyprswitch dispatch -r"))

-- Cycle windows with mainMod + tab
hl.bind(mainMod .. " + tab", hl.dsp.window.cycle_next())

-- Move focus with mainMod + arrow keys / hjkl
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Minimize
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" }) -- You'll probably like this.

-- PiP
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true })

-- firefox noti, extension
hl.window_rule({
    match          = { class = "^firefox$", title = "^$" },
    float          = true,
    move           = { "monitor_w*0.5-window_w", "0" },
    suppress_event = "activatefocus",
})

hl.window_rule({ match = { class = "^mpv$" }, float = true })

-- volume popup (waybar speaker icon), top right under the bar
hl.window_rule({
    match = { class = "^com.saivert.pwvucontrol$" },
    float = true,
    pin   = true,
    size  = { 640, 560 }, -- narrower makes pwvucontrol switch to a cramped bottom tab bar
    move  = { "monitor_w-648", "38" },  -- width + 8px gap; window_w is evaluated before size applies
})

-- flameshot
hl.window_rule({ match = { class = "^(flameshot)$" }, float = true, move = { 0, 0 }, pin = true })
hl.window_rule({ match = { class = "^(net.lutris.Lutris)$" }, float = true })

-- steam
hl.window_rule({ match = { initial_class = "^steam$" }, no_initial_focus = true })
hl.window_rule({ match = { class = "^steam$" }, workspace = "4" })
-- steam games
local games = [[dota2|steam_app_\d+]]
hl.window_rule({ match = { class = "^(" .. games .. ")$" }, workspace = "3" })
hl.window_rule({ match = { initial_class = "^(" .. games .. ")$" }, workspace = "3" })

-- wwm
hl.window_rule({ match = { title = "^Where Winds Meet$" }, workspace = "3" })
hl.window_rule({
    match      = { class = "^steam_app_3564740$", title = "^Where Winds Meet$" },
    workspace  = "3",
    fullscreen = true,
})
hl.window_rule({
    match      = { initial_title = "^wwm.exe$", initial_class = "^steam_app_default$" },
    workspace  = "3",
    fullscreen = true,
})
-- hl.window_rule({ match = { initial_title = "^燕雲十六聲$" }, workspace = "3" })

-- poe2 + ee2
hl.window_rule({ match = { title = "^(Path of Exile 2)$" }, workspace = "3" })
-- hl.window_rule({ match = { class = "^(exiled-exchange-2)$" }, float = true, pin = true, no_blur = true })

-- zen
hl.window_rule({ match = { class = "^zen-alpha$" }, size = { "monitor_w*0.5", "monitor_h*0.8" } })

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
