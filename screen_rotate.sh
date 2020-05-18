#!/usr/bin/env bash

if [[ "${1}" != "left" && "${1}" != "normal" ]]; then
    echo "Usage: ${0} [normal|left]"
    exit 1
fi

focused_mon="$(bspc query -M -m .focused --names)"

# rotate monitor
xrandr --output "${focused_mon}" --rotate "${1}"

# restart polybar
polybar-msg cmd restart

# reapply backgrounds
feh --bg-fill ~/.local/share/background/*
