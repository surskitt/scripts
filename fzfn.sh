#!/usr/bin/env bash

if [ -z "${DISPLAY}" ]; then
    echo "Error: No X display found"
    exit 1
fi

usage() {
    echo "Usage: input | ${0} [-I IMAGE_PROCESSOR] [-F IMAGE_FIELD] [-h] -- ...FZF_ARGS"
    echo "Options:"
    echo "  -I    Command to run to get fn of image"
    echo "  -F    Input field to process for image"
    echo "  -H    Hide image field"
    echo
    echo "run fzf -h for further args"
}

fzf_field_cmd() {
    n="${1}"

    if [ "${n}" = 1 ]; then
        echo 2..
        exit
    fi

    echo "$((n-1)),$((n+1)).."
}

if [ ! -p /dev/stdin ]; then
    echo "Error: Pipe input to stdin to use"
    echo
    usage
    exit
fi

IMAGE_FIELD=1
IMAGE_PROCESSOR="echo"
IMAGE_HIDE=false

while getopts 'I:F:Hh' opt ; do
    case "${opt}" in
        I)
            IMAGE_PROCESSOR="${OPTARG}"
            ;;
        F)
            IMAGE_FIELD="${OPTARG}"
            ;;
        H)
            IMAGE_HIDE=true
            ;;
        h)
            usage
            exit
            ;;
        ?)
            echo "${OPTARG}"
            ;;
    esac
done

shift $((OPTIND -1))

if ! type "${IMAGE_PROCESSOR}" >/dev/null 2>&1; then
    echo "${IMAGE_PROCESSOR} is not a valid command"
    exit 1
fi

if "${IMAGE_HIDE}"; then
    FZF_HIDE_ARG="--with-nth $(fzf_field_cmd ${IMAGE_FIELD})"
fi

cat | fzf ${FZF_HIDE_ARG} --bind "ctrl-i:execute(dunstify -i \$(${IMAGE_PROCESSOR} {${IMAGE_FIELD}}) '')" "${@}"
