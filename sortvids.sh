#!/usr/bin/env zsh

usage() {
    print -u2 "Usage: ${(%):-%x} -s src -d dest"
}

while getopts 's:d:Dh' opt; do
    case "${opt}" in
        s)
            src="${OPTARG}"
            ;;
        d)
            dest="${OPTARG}"
            ;;
        h)
            usage
            ;;
        D)
            DEPTH_OPT='-maxdepth 1'
            ;;
        ?)
            usage
            exit 1
    esac
done
shift $(( OPTIND - 1 ))

{ [[ -z "${src}" ]] || [[ -z "${dest}" ]] || [ ! -d "${src}" ] || [ ! -d "${dest}" ] } && {
    print -u2 "ERROR: src and dest arguments are mandatory and must exist"
    usage
    exit 1
}

pipe=/tmp/mpv_sort_pipe
rm -f $pipe
mkfifo $pipe
trap "rm -f $pipe" EXIT

# mpvbinds="ctrl-z:execute(vared -c a; echo $a),ctrl-x:execute(echo 'show-text \${filename}' > ${pipe}),ctrl-c:execute(echo 'seek 30' > ${pipe})"
mpvbinds="ctrl-z:execute(read -e < /dev/tty),ctrl-x:execute(echo 'show-text \${filename}' > ${pipe}),ctrl-c:execute(echo 'seek 30' > ${pipe}),ctrl-v:execute(echo 'keypress ctrl+del' > ${pipe})"

mpv -fs --input-file=${pipe} --player-operation-mode=pseudo-gui &

# find "${src}/" \( -iname '*.mp4' -o -iname '*.flv' -o -iname '*.avi' \) 
find "${src}/" \( -iname '*.mp4' -o -iname '*.flv' -o -iname '*.avi' -o -iname '*.wmv' -o -iname '*.mkv' -o -iname '*.mov' -o -iname '*.m4v' -o -iname '*.mpg' -o -iname '*.webm' \) | grep -v '(' | sort | while read vid; do
    print "${vid}"
    ffprobe "${vid}" 2>/dev/null || continue
    print "loadfile \"${vid}\"" > ${pipe}

    mvdir=$(find "${dest}" -type d|sed "s#${dest}/##"|sort|fzf +m --no-mouse --bind "${mpvbinds}")

    [ ! -z "${mvdir}" ] && {
        print "${vid} -> ${mvdir##*/}"
        mkdir -p "${dest}/${mvdir##*/}"
        TS_SOCKET=/tmp/mpv_mv tsp mv "${vid}" "${dest}/${mvdir##*/}/"
    }
done
