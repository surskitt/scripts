#!/usr/bin/env bash

if [ -p /tmp/bspc_show_desktop_fifo ]; then
    echo "restoring" > /tmp/bspc_show_desktop_fifo
    exit
fi

curr_desktops=$(bspc query -D -d .active --names)
curr_desktop=$(bspc query -D -d .focused --names)
curr_monitor=$(bspc query -M -d "${curr_desktop}")

mkfifo /tmp/bspc_show_desktop_fifo

echo "hiding"

bspc query -M|while read -r m; do
    bspc monitor "${m}" -a "d_${m}"
    bspc desktop -f "d_${m}"
done

bspc desktop -f "d_${curr_monitor}"

cat /tmp/bspc_show_desktop_fifo

for i in ${curr_desktops}; do
    bspc desktop -f "$i"
done

bspc desktop -f "${curr_desktop}"

rm /tmp/bspc_show_desktop_fifo

bspc query -M|while read -r m; do
    bspc desktop "d_${m}" -r
done
