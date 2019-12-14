#!/usr/bin/env bash

cmd="${1}"
on="${2}"
off="${3}"

cmdpipe="/tmp/${cmd}_toggle"
cmdlog="/tmp/${cmd}_stdout.log"

# : > "${cmdlog}"

if [ -p "${cmdpipe}" ]; then
    echo "${cmd} is already being monitored" >&2
    exit 1
fi

mkfifo "${cmdpipe}"

trap "rm ${cmdpipe}; exit" EXIT

${cmd} >"${cmdlog}" 2>&1 &
state=true
echo "${on}"

while <"${cmdpipe}" >/dev/null; do
    if ! $state ; then
        ${cmd} >"${cmdlog}" 2>&1 &
        state=true
        echo "${on}"
        # echo "${on}" > "${cmdpipe}"
    else
        pkill "${cmd}"
        state=false
        echo "${off}"
        # echo "${off}" > "${cmdpipe}"
    fi
done
