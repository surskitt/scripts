#!/usr/bin/env bash

usage() {
    echo "Usage: $0 DOWNLOAD_DIRECTORY"
}

[ $# -lt 1 ] && {
    usage >&2
    exit 1
}

[ ! -d "${1}" ] && {
    echo "Error: ${1} is not a directory" >&2
    usage >&2
    exit 1
}

shopt -s nocasematch

DOWNLOAD_DIRECTORY="${1}"

for f in "${DOWNLOAD_DIRECTORY}"/*;{
    [ -d "${f}" ] && continue
    # ext=$(echo "${f##*\.}"|tr '[:upper:]' '[:lower:]')
    case "${f##*\.}" in
        aria2|download|crdownload)
            continue
            ;;
        png|jpg|gif)
            type="image"
            ;;
        mp4|webm|mkv|mov|srt)
            type="video"
            ;;
        mp3|wav|m4a|flac)
            type="audio"
            ;;
        txt|ini|cfg)
            type="text"
            ;;
        pdf|epub|doc|docx)
            type="doc"
            ;;
        zip|gz|rar|iso|img|7z)
            type="archive"
            ;;
        torrent)
            type="torrent"
            ;;
        sh|py|pl|rb|jar|rpm)
            type="exe"
            ;;
        exe|msi|ps1|bat|reg|dll|application)
            type="winexe"
            ;;
        *)
            type="other"
            ;;
    esac

    mkdir -p "${DOWNLOAD_DIRECTORY}/sorted/${type}"
    mv "${f}" "${DOWNLOAD_DIRECTORY}/sorted/${type}"
}
