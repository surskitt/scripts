#!/usr/bin/env bash

files=(${@})
filecount="${#files[@]}"

monitors="$(xrandr --listactivemonitors|head -1|cut -d ' ' -f 2)"

for f in "${files[@]:0:${monitors}}"; do
    if [ ! -f "${f}" ]; then
        echo "ERROR: ${f} does not exist" >&2
        exit 1
    fi
done

feh --bg-fill ${files[@]:0:${monitors}}

for i in $(seq ${monitors}); do
    n=$((i-1))

    file="${files[${n}]}"
    if [[ ${file} != "" ]]; then
        ln -sf "${file}" ~/.local/share/background/${i}
    fi
done
