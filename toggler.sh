#!/usr/bin/env bash

usage() {
    echo i am the usage
}

run_cmd() {
    cmd=$1
    cmdlog="/tmp/${cmd}_stdout.log"
    ${cmd} ${args} >"${cmdlog}" 2>&1 &
}

cmd_pipe="/tmp/toggler_pipe"
state_file="/tmp/toggler_state"

if [ -p "${cmd_pipe}" ]; then
    echo "toggler pipe already exists" >&2
    exit 1
fi

if [ -f "${cmd_pipe}" ]; then
    rm "${cmd_pipe}"
fi

mkfifo "${cmd_pipe}"

trap "rm -f ${cmd_pipe} ${state_file}; " EXIT

declare -A state

while read action cmd args <"${cmd_pipe}"; do

    if [[ "${action}" != "monitor" ]] && [ ! ${state[$cmd]+_} ]; then
        echo "${cmd} is not being monitored" >&2
        continue
    fi

    case "${action}" in
        monitor)
            if ${state[$cmd]+false}; then
                run_cmd "${cmd}"
                state["${cmd}"]=true
            else
                echo "${cmd} is already being monitored" >&2
            fi
            ;;
        unmonitor)
            echo "unmonitoring"
            ;;
        on)
            if ! pgrep "${cmd}" >/dev/null; then
                run_cmd "${cmd}"
            fi
            state["${cmd}"]=true
            ;;
        off)
            pkill "${cmd}"
            state["${cmd}"]=false
            ;;
        toggle)
            if ${state[$cmd]}; then
                pkill "${cmd}"
                state[${cmd}]=false
            else
                run_cmd "${cmd}"
                state[${cmd}]=true
            fi
            ;;
        status)
            echo "${state[$cmd]}"
            ;;
        *)
            usage >&2
            ;;
    esac

    (
        for c in "${!state[@]}"; do
            echo -n "${c}=${state[$c]} "
        done
        echo
    ) >> "${state_file}"

done
