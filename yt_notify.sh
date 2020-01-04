#!/usr/bin/env bash

if [ ! -f /tmp/last_vid ]; then
    youtube_sm_parser -l '{id}' 2>/dev/null|head -1 > /tmp/last_vid
    exit
fi

last_vid=$(</tmp/last_vid)

if [ -z "${last_vid}" ]; then
    youtube_sm_parser -l '{id}' 2>/dev/null|head -1 > /tmp/last_vid
    exit
fi

mapfile -t vids < <(youtube_sm_parser -l '{title}	{uploader}	{id}' 2>/dev/null)

for vid in "${vids[@]}"; do
    IFS='	' read title uploader id <<< "${vid}"

    if [ "${last_vid}" = "${id}" ]; then
        break
    fi

    img_url="https://img.youtube.com/vi/${id}/hqdefault.jpg"

    DIRNAME="$(dirname $0)"
    ${DIRNAME}/notify-imgurl.sh "${img_url}" "${title}" "${uploader}"
done

echo "${vids##*	}" > /tmp/last_vid
