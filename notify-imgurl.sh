#!/usr/bin/env sh

if [ ${#} -lt 2 ]; then
    echo "Usage: notify-imgurl.sh <URL> msg" >&2
    exit 1
fi

url="${1}"
title="${2}"
shift 2
msg="${*}"

tmpdir="/tmp/albumart"
sum=$(md5sum <<< ${url})
fn="${sum% *}"
path="${tmpdir}/${fn}"

mkdir -p "${tmpdir}"

if [ ! -f "${path}" ]; then
    curl -q -o "${path}" "${url}"
fi

dunstify -i "${path}" "${title}" "${msg}"
