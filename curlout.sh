#!/usr/bin/env bash

TEMPDIR=/tmp/curlout

mkdir -p "${TEMPDIR}"

fn="${TEMPDIR}/${1##*/}"

if [ -f "${fn}" ]; then
    echo "${fn}"
    exit
fi

curl -s "${1}" -o "${fn}" && echo "${fn}"
