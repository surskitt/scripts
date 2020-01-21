#!/usr/bin/env bash

for i in "${@}"; do
    bspc query -D -d .active --names | while read -r d; do
        bspc query -N -d "${d}" -n '.window'
    done | while read -r n; do
        bspc node "${n}" -f
        xdotool type "${i}"
    done
done
