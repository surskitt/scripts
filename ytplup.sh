#!/usr/bin/env bash

for i in ~/ytdl/playlists/*/url.txt; do
    URL=$(<"${i}")

    echo "Downloading ${URL} (${i})"
    youtube-dl.sh "${URL}"
done
