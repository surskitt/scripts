#!/usr/bin/env bash

usage() {
    echo "Usage: ${0} [-b]"
}

SEARCHDIR="${PWD}"
NOCROP=false

while getopts 'd:e:nh' opt; do
    case "${opt}" in
        d)
            SEARCHDIR="${OPTARG}"
            ;;
        e)
            EXTRA="${OPTARG}"
            ;;
        n)
            NOCROP=true
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
shift $(( OPTIND - 1 ))

# TMPDIR="/tmp/tmp.j7EKMxx5dz"
TMPDIR="$(mktemp -d)"

echo "${TMPDIR}"

for i in "${SEARCHDIR}"/*/; do
    if [ -f "${i}/.folder" ]; then
        continue
    fi

    echo "Processing: ${i}"

    f="$(basename "${i}")"
    fd="${TMPDIR}/${f}"

    bbid.py -s "${f} ${EXTRA}" --limit 50 --adult-filter-off --filters "+filterui:imagesize-large" -o "${fd}"
    selected=$(sxiv -ftro "${fd}"|head -1)
    if [ "${selected}" = "" ]; then
        continue
    fi

    if "${NOCROP}"; then
        cp "${selected}" "${i}/.folder"
        continue
    fi

    sd="${fd}/selected"
    mkdir "${sd}"
    cp "${selected}" "${sd}"

    inbac "${sd}" -a 1 1
    cropped="${sd}/crops/${selected##*/}"
    if [ ! -f "${cropped}" ]; then
        continue
    fi

    cp "${cropped}" "${i}/.folder"
done
