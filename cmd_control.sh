#!/usr/bin/env bash
usage() {
    echo "Usage: ${0} [-i]"
}


ID="${1}"

while getopts 'i:bh' opt; do
    case "${opt}" in
        i)
            ID="${OPTARG}"
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
    echo kill > "${controller}"
    exit
fi

${*} &
pid="${!}"

echo "Controlling '${*}' with pid ${pid}"

mkfifo "${controller}"

while read; do
    kill "${pid}"
done < "${controller}"

rm "${controller}"
