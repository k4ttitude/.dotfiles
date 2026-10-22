-- Personal input overrides. Omarchy already uses repeat_rate 40 / repeat_delay
-- 250 and takes kb_layout from /etc/vconsole.conf.

hl.config({
    input = {
        follow_mouse = 0,
    },
})

hl.device({
    name        = "realtek-mchose-a7-ultra(re)",
    sensitivity = -0.75,
})
