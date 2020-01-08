#!/usr/bin/env bash

#
# find git repos under working directory where develop is ahead of master
#

usage() {
    echo "Usage: ${0} [-v] [-d ROOTDIR] [-s SRC] [-d DEST] [-h]"
    echo "Options:"
    echo "  -v    verbose output, show all found repo status"
    echo "  -D    specify root search directory"
    echo "  -s    specify source branch (default develop)"
    echo "  -d    specify destination branch (default master)"
    echo "  -h    show this help"
}

VERBOSE=false
SRC=develop
DEST=master

while getopts 'vD:s:d:h' opt; do
    case "${opt}" in
        v)
            VERBOSE=true
            ;;
        D)
            cd "${OPTARG}"
            ;;
        s)
            SRC="${OPTARG}"
            ;;
        d)
            DEST="${OPTARG}"
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

gr() {
    git --git-dir "${1}" --work-tree "${1%/.git}" "${@:2}"
}

branch_exists() {
    gr "${1}" rev-parse --verify "${2}" >/dev/null 2>&1
}

colour() {
    echo -e "\033[${1};${2}m${@:3}\033[0m"
}

red() {
    colour 0 31 "${*}"
}

yellow() {
    colour 1 33 "${*}"
}

green() {
    colour 0 32 "${*}"
}

find "${PWD}" -type d -name .git 2>/dev/null | sort | while read g; do
    repo="${g%/.git}"

    if ! branch_exists "${g}" "${SRC}"; then
        "${VERBOSE}" && red "${repo}: no "${SRC}" branch"
        continue
    fi

    if ! branch_exists "${g}" "${DEST}"; then
        "${VERBOSE}" && red "${repo}: no "${DEST}" branch"
        continue
    fi

    commits=$(gr "${g}" log --oneline ${DEST}..${SRC}|wc -l)

    if [[ "${commits}" -eq 0 ]]; then
        "${VERBOSE}" && green "${repo}: ${SRC} is even with ${DEST}"
    else
        yellow "${repo}: ${SRC} is ${commits} commit(s) ahead of ${DEST}"
    fi
done
