#!/usr/bin/env bash

TAB="	"

if [ "${#}" -eq 0 ]; then
    dir="${PWD}"
else
    dir="${1}"
fi

if ! [ -d "${dir}" ]; then
    echo "error: ${dir} is not a directory" >&2
    exit 1
fi

no_refresh=true

cache_size=$(wc -l "${dir}/.thumbs.tsv" 2>/dev/null|cut -d ' ' -f 1 || 0)
file_count="$(ls "${dir}"|wc -l)"

if [[ ${cache_size} -ne ${file_count} ]]; then
    no_refresh=false
fi

if [[ -f "${dir}/.thumbs.tsv" && $no_refresh == true ]]; then
    fl=$(< "${dir}/.thumbs.tsv")
else
    f=$(ls -1 -d "${dir}"/*/ 2>/dev/null ; find "${dir}" -maxdepth 1 -type f -not -path '*/\.*')

    fl=$(echo "${f}"|while read fn; do
        p=$(previewer.sh "${fn}")

        echo "${p}${TAB}${fn}"
    done)

    echo "${fl}" > "${dir}/.thumbs.tsv"
fi

s=$(echo "${fl}"|while IFS=$"${TAB}" read fn _; do echo "${fn}"; done|sxiv -ftio|head -1)

if [[ "${s}" == "" ]]; then
    exit
fi

grep "${s}" <<< "${fl}"|cut -d "${TAB}" -f 2
