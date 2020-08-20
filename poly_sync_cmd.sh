#!/usr/bin/env bash

usage() {
    echo "Usage:"
}


# DELAY=5
MEMBER=${MONITOR_ID:-1}

while getopts "m:x:h" opt; do
    case "${opt}" in
        m)
            MEMBER="${OPTARG}"
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

CMD_HASH=$(echo -n "${CMD}"|sha1sum|cut -d ' ' -f 1)
CMD_LOG="/tmp/${CMD_HASH}_sync.log"

if [[ "${MEMBER}" == 1 ]]; then
    ${CMD} | tee -a "${CMD_LOG}"
else
    echo ""
    while ! [ -f "${CMD_LOG}" ]; do sleep 1; done
    tail -f "${CMD_LOG}"
fi
