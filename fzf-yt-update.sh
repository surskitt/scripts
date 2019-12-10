#!/usr/bin/env bash

export DISPLAY=:0

newest=$(head -1 ~/.cache/yt/vids.tsv)

~/.scripts/fzf-yt.sh -r

while read -r line; do
    [ "${newest}" == "${line}" ] && break
    IFS='	' read -r title id <<< "${line}"
    dunstify -i "$HOME/.cache/yt/${id}.jpg" "${title}"
done < ~/.cache/yt/vids.tsv
