#!/usr/bin/env bash

source <(grep export $1)

cat <<EOF
{
  "colors": {
    "color0": "$COLOR_01",
    "color1": "$COLOR_02",
    "color2": "$COLOR_03",
    "color3": "$COLOR_04",
    "color4": "$COLOR_05",
    "color5": "$COLOR_06",
    "color6": "$COLOR_07",
    "color7": "$COLOR_08",
    "color8": "$COLOR_09",
    "color9": "$COLOR_10",
    "color10": "$COLOR_11",
    "color11": "$COLOR_12",
    "color12": "$COLOR_13",
    "color13": "$COLOR_14",
    "color14": "$COLOR_15",
    "color15": "$COLOR_16"
  },
  "special": {
    "foreground": "$FOREGROUND_COLOR",
    "background": "$BACKGROUND_COLOR",
    "cursor": "$CURSOR_COLOR"
  }
}
EOF
