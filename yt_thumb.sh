#!/usr/bin/env bash

if [ $# -lt 1 ]; then
    read -r yt_url _
else
    yt_url="${1}"
fi

yt_id="${yt_url##*=}"

yt_thumb_url="https://img.youtube.com/vi/${yt_id}/hqdefault.jpg"
yt_thumb_fn="${HOME}/.cache/yt_img/${yt_id}.jpg"

mkdir -p ~/.cache/yt_img

[ ! -f "${yt_thumb_fn}" ] && {
    curl "${yt_thumb_url}" -o "${yt_thumb_fn}" -s
}

echo "${yt_thumb_fn}"
