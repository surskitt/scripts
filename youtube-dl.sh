#!/usr/bin/env bash

export TS_SOCKET=/tmp/socket-ts.yt

_tsp() {
    if hash tsp 2>/dev/null; then
        tsp "${@}"
    else
        "${@}"
    fi
}

outdir=~/ytdl
fn="${outdir}/%(upload_date)s - %(title)s - %(id)s (%(extractor)s).%(ext)s"

_tsp youtube-dl \
    --ignore-config \
    --no-color \
    --no-playlist \
    --mark-watched \
    --merge-output-format mkv \
    --ignore-errors \
    --retries 10 \
    --no-mtime \
    --sub-lang en,en_US \
    --write-sub \
    --embed-subs \
    --add-metadata \
    --format 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' \
    --output "${fn}" \
    "${@}"
