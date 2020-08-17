#!/usr/bin/env bash

usage() {
    echo "Usage:"
}


DELAY=5

while getopts "d:x:h" opt; do
    case "${opt}" in
        d)
            DELAY="${OPTARG}"
            ;;
        x)
            CMD="${OPTARG}"
            ;;
        h)
            usage
            exit
            ;;
        ?)
            usage >&2
            exit 1
            ;;
    esac
done

d1="$(( RANDOM % DELAY ))"
d2="$(( RANDOM % 10 ))"
d="${d1}.${d2}"

sleep "${d}"

CMD_HASH=$(echo -n "${CMD}"|sha1sum|cut -d ' ' -f 1)
CMD_LOG="/tmp/${CMD_HASH}_sync.log"

if [ -f "${CMD_LOG}" ]; then
    tail -f "${CMD_LOG}"
    exit
fi

cleanup() {
    rm "${CMD_LOG}"
}

trap "cleanup" SIGINT

${CMD} | tee -a "${CMD_LOG}"
