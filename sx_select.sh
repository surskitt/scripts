#!/usr/bin/env bash

TAB="	"

if [ "${#}" -eq 0 ]; then
    dir="${PWD}"
else
    dir="${1}"
fi

f=$(ls -1 -d "${dir}"/*/ 2>/dev/null ; find "${dir}" -maxdepth 1 -type f -not -path '*/\.*')

fl=$(echo "${f}"|while read fn; do
    p=$(previewer.sh "${fn}")

    echo "${p}${TAB}${fn}"
done)

s=$(echo "${fl}"|while IFS=$"${TAB}" read fn _; do echo "${fn}"; done|sxiv -ftio|head -1)

if [[ "${s}" == "" ]]; then
    exit
fi

grep "${s}" <<< "${fl}"|cut -d "${TAB}" -f 2
