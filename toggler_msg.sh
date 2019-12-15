#!/usr/bin/env bash

state_file=/tmp/toggler_state

if [ ! -f "${state_file}" ]; then
    echo "ERROR: toggler is not running" >&2
    exit 1
fi

declare -A icons
for i in "${@}"; do
    if [[ "${i}" != *"="* ]]; then
        echo "Error: ${i} not in cmd=icon format" >&2
        continue
    fi

    cmd="${i%=*}"
    icon="${i#*=}"

    icons[${cmd}]="${icon}"
done

tail -n 1 -f "${state_file}"|while read -r line; do
    cmd_out=()
    readarray -d " " cmds <<< "${line}"
    for cmd in "${cmds[@]}"; do
        cmd_name="${cmd%=*}"
        cmd_state="${cmd#*=}"

        if ${cmd_state}; then
            # echo -n "%{F-}${icons[$cmd_name]} "
            cmd_out+=("%{F-}${icons[$cmd_name]}")
        else
            # echo -n "%{F#65737E}${icons[$cmd_name]} "
            cmd_out+=("%{F#65737E}${icons[$cmd_name]}")
        fi
    done
    echo "${cmd_out[@]}"

done
