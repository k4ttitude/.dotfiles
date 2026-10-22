-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

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

-- GTK only honors whole numbers; match the monitor scale above.
-- Omarchy's template defaults to 2 for HiDPI laptops.
hl.env("GDK_SCALE", "1")
