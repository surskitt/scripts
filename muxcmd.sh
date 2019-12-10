#!/usr/bin/env bash

usage() {
    echo "Usage: ${0} (-c cmd | -t tmuxp_project)"
}

while getopts 'c:t:h' opt; do
    case "${opt}" in
        c)
            CMD="${OPTARG}"
            ;;
        t)
            TMUXP_PROJECT="${OPTARG}"
            ;;
        ?)
            usage
            exit 1
    esac
done
shift $(( OPTIND - 1 ))

if [[ -z "${CMD}" ]] && [[ -z "${TMUXP_PROJECT}" ]]; then
    echo "ERROR: One of '-c' or '-t' must be passed" >&2
    usage >&2
    exit 1
fi

if [[ -n "${CMD}" ]] && [[ -n "${TMUXP_PROJECT}" ]]; then
    echo "ERROR: One of '-c' or '-t' must be passed" >&2
    usage >&2
    exit 1
fi

if [[ -n $CMD ]]; then
    tmux new-session -s "${CMD}" -n ' ' "${CMD}" || tmux attach -t "${CMD}"
fi

if [[ -n $TMUXP_PROJECT ]]; then
    tmuxp load -y "${TMUXP_PROJECT}"
fi
