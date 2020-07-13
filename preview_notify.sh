#!/usr/bin/env bash

FILE="${1}"

if [ ! -f "${FILE}" ]; then
    echo "Error: ${FILE} does not exist"
    exit 1
fi

IMG="$(previewer.sh "${FILE}")"

notify-send -i "${IMG}" "${FILE}"
