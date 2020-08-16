#!/usr/bin/env bash

usage() {
    echo "Usage: ${0} [-q]"
}

MSG=" new packages"

while getopts 'qh' opt; do
    case "${opt}" in
        q)
            MSG=""
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

count="$(pacman -Supq|wc -l)"

echo " ${count}${MSG}"
