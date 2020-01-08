#!/usr/bin/env bash

#
# find git repos under working directory where develop is ahead of master
#

usage() {
    echo "Usage: ${0} [-v] [-h]"
    echo "Options:"
    echo "  -v    verbose output, show all found repo status"
    echo "  -h    show this help"
}

VERBOSE=false
while getopts 'vh' opt; do
    case "${opt}" in
        v)
            VERBOSE=true
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

find "${PWD}" -type d -name .git|while read g; do
    repo="${g%/.git}"

    if ! gr "${g}" rev-parse --verify develop >/dev/null 2>&1; then
        "${VERBOSE}" && red "${repo}: no develop branch"
        continue
    fi

    commits=$(gr "${g}" log --oneline master..develop|wc -l)

    if [[ "${commits}" -eq 0 ]]; then
        "${VERBOSE}" && green "${repo}: develop is even with master"
    else
        yellow "${repo}: develop is "${commits}" commits ahead of master"
    fi
done
