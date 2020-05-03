#!/usr/bin/env bash

WINSCALE="${1:-3}"

STICKYWIN="$(bspc query -N -n .sticky -n .floating|head -1)"

if [[ ! -z "${STICKYWIN}" ]]; then
    WIN="${STICKYWIN}"
else
    WIN="$(pfw)"
fi

if [[ "${WINSCALE}" -eq 0 ]]; then
    bspc node "${WIN}" -t tiled
    bspc node "${WIN}" -g sticky=false
    exit
fi

ROOT="$(lsw -r)"
SW="$(wattr w ${ROOT})"
SH="$(wattr h ${ROOT})"

WW="$((SW/${WINSCALE}))"
WH="$((SH/${WINSCALE}))"

X="$((SW-WW-14))"

bspc node "${WIN}" -t floating
bspc node "${WIN}" -g sticky=true
wtp "${X}" 10 "${WW}" "${WH}" "${WIN}"
