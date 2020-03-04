#!/usr/bin/env bash

MONITOR_DIR="${1}"

script_dir="$(dirname $0)"

inotifywait -m -e create -r "${MONITOR_DIR}" --format '%w%f'|while read line; do
    "${script_dir}/poly_notify.sh" " New file in ${MONITOR_DIR}: ${line##${MONITOR_DIR}/}"
done
