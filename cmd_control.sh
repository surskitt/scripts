#!/usr/bin/env bash
usage() {
    echo "Usage: ${0} [-i] [-s] [-k]"
}


ID="${1}"
START=true
KILL=true

while getopts 'i:skbh' opt; do
    case "${opt}" in
        i)
            ID="${OPTARG}"
            ;;
        s)
            KILL=false
            ;;
        k)
            START=false
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

controller="/tmp/controller_${ID}"

if [ -p "${controller}" ]; then
    if $KILL; then
        echo kill > "${controller}"
    fi
    exit
fi

if ${START}; then
    ${*} &
    pid="${!}"

    echo "Controlling '${*}' with pid ${pid}"

    mkfifo "${controller}"

    while read; do
        kill "${pid}"
    done < "${controller}"

    rm "${controller}"
fi
