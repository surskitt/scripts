#!/usr/bin/env bash

while getopts 'u' flag; do
    case "${flag}" in
        u) USER_ARG="--user "
            ;;
        *)
            ;;
    esac
done
shift $((OPTIND-1))

unit_args() {
    for i in "${@}"; do
        echo -n "--unit ${i} "
    done
    echo
}

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

journalctl -n 1 ${USER_ARG} -f -o cat $(unit_args "${!icons[@]}") | while read -r; do
    svc_out=()
    for svc in "${!icons[@]}"; do
        if [ "$(systemctl ${USER_ARG} is-active "${svc}")" = "active" ]; then
            # echo -n "%{F-}${icons[$svc]} "
            svc_out+=("%{F-}${icons[$svc]}")
        else
            # echo -n "%{F#65737E}${icons[$svc]} "
            svc_out+=("%{F#65737E}${icons[$svc]}")
        fi
    done
    echo "${svc_out[@]}"
done
