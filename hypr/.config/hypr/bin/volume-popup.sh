#!/bin/sh

# Toggle the pwvucontrol popup (positioned by a window rule in hyprland.lua)
class="com.saivert.pwvucontrol"

addr=$(hyprctl clients -j | jq -r --arg c "$class" '.[] | select(.class == $c) | .address' | head -n1)

if [ -n "$addr" ]; then
  hyprctl dispatch "hl.dsp.window.close({ window = \"address:$addr\" })" >/dev/null
else
  pwvucontrol &
fi
