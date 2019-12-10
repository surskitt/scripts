#!/usr/bin/env bash

trap 'kill $(jobs -p)' EXIT

export TS_SOCKET=/tmp/socket-ts.yt
output_dir=~/ytdl/youtube/

# start image display daemon
~/.scripts/img.py -p $$ -w 70 -d &

preview_command="$HOME/.scripts/yt_thumb.sh {-1}|$HOME/.scripts/img.py -p $$ -c -s"

jq -r '.[]|[.title, .uploader, .link]|join(" - ")' ~/.cache/yt_subs/subs.json|
    fzf --layout=reverse --with-nth='1..-3' -m --margin=0,0,0,69 --preview-window=left:0 --preview="${preview_command}"|
    rev|cut -d ' ' -f 1|rev|
    while read url; do tsp youtube-dl -o "${output_dir}/%(title)s.%(ext)s" $url; done
