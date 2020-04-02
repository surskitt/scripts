#!/usr/bin/env bash

if [ "${#}" -lt 1 ]; then
    jsonfile=~/.config/fzf-weechat/channels.json
else
    jsonfile="${1}"
fi

[ ! -f "${jsonfile}" ] && {
    echo "Error: ${jsonfile} does not exist" >&2
    exit 1
}

json=$(< "${jsonfile}")

key=$(jq -r 'keys_unsorted|.[]' <<< "${json}"|fzf +m --layout=reverse-list)
[ -z "${key}" ] && exit 1

item=$(jq -r ".\"${key}\"" <<< "${json}")

echo "/buffer ${item}"|inwee
