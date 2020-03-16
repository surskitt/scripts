#!/usr/bin/env bash

usage() {
    echo "Usage: ${0} [-b]"
}

while getopts 'bh' opt; do
    case "${opt}" in
        b)
            FOCUS_ARG="focus=off"
            ;;
        h)
            usage
            exit
            ;;
        ?)
            usage >&2
            exit 1
    esac
done
shift $(( OPTIND - 1 ))

bspc rule -a \* -o state=floating "${FOCUS_ARG}"
exec ${*}

bspc rule -a \* -o state=tiled focus=on
