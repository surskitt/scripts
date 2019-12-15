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

UNIT=$1

if [[ "$(systemctl ${USER_ARG} is-active $UNIT)" = active ]]; then
    systemctl ${USER_ARG} stop "${UNIT}"
else
    systemctl ${USER_ARG} start "${UNIT}"
fi
