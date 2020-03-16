#!/usr/bin/env bash

if [ -z "${DISPLAY}" ]; then
    echo "Error: No X display found"
    exit 1
fi

PREVIEWER="floater.sh -b cmd_control.sh -i 999 sxiv -a -b -g 500x500-10+10 ~/.cache/preview_img"
PREVIEWER_KILL="floater.sh -b cmd_control.sh -k -i 999 sxiv -a -b -g 500x500-10+10 ~/.cache/preview_img"

usage() {
    echo "Usage: input | ${0} [-I IMAGE_PROCESSOR] [-F IMAGE_FIELD] [-h] -- ...FZF_ARGS"
    echo "Options:"
    echo "  -I    Command to run to get fn of image"
    echo "  -F    Input field to process for image"
    echo "  -H    Hide image field"
    echo "  -O    Override the field index used to remove image from notification"
    echo
    echo "run fzf -h for further args"
}

fzf_field_cmd() {
    n="${1}"

    if [ "${n}" = 1 ]; then
        echo 2..
        exit
    fi

    echo ..

    # echo "$((n-1)),$((n+1)).."
}

if [ ! -p /dev/stdin ]; then
    echo "Error: Pipe input to stdin to use"
    echo
    usage
    exit
fi

IMAGE_FIELD=1
IMAGE_PROCESSOR=echo
IMAGE_HIDE=false

while getopts 'I:F:HO:h' opt ; do
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
        O)
            IMAGE_HIDE_OVERRIDE="${OPTARG}"
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

export IMAGE_PROCESSOR
export IMAGE_FIELD

shift $((OPTIND -1))

if ! type "${IMAGE_PROCESSOR}" >/dev/null 2>&1; then
    echo "${IMAGE_PROCESSOR} is not a valid command"
    exit 1
fi

FZF_FIELDS_NO_IMG="$(fzf_field_cmd ${IMAGE_FIELD})"

if "${IMAGE_HIDE}"; then
    FZF_HIDE_ARG="--with-nth ${IMAGE_HIDE_OVERRIDE:-${FZF_FIELDS_NO_IMG}}"
fi

# cat | fzf ${FZF_HIDE_ARG} --bind "ctrl-P:execute(dunstify -r 1001 -i \$(${IMAGE_PROCESSOR} {${IMAGE_FIELD}}) {${IMAGE_HIDE_OVERRIDE:-${FZF_FIELDS_NO_IMG}}})" "${@}"
cat | fzf --preview='cp $(${IMAGE_PROCESSOR} {1}) ~/.cache/preview_img' --bind "ctrl-P:execute(${PREVIEWER} >/dev/null 3>&1 &)" --preview-window=down:0% "${@}"

${PREVIEWER_KILL}
