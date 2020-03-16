#!/usr/bin/env bash

TEMPDIR=/tmp/curlout

mkdir -p "${TEMPDIR}"

f="${1##*/}"
f="${f##*\=}"
fn="${TEMPDIR}/${f}"

if [ -f "${fn}" ]; then
    echo "${fn}"
    exit
fi

curl -L -s "${1}" -o "${fn}" && echo "${fn}"
