#!/usr/bin/env bash

nl="
"
empty="[${nl}${nl}]"

USER=shanedabes
PASS="${GH_STAR_LISTER_PAT}"

if [ -z "${PASS}" ]; then
    echo "Error: GH_STAR_LISTER_PAT not set" >&2
    exit 1
fi

api_url() {
    echo "https://api.github.com/user/repos?per_page=100&page=${1}"
}

stars() {
    page=1

    while :; do
        url="$(api_url ${page})"
        j=$(curl -s -u "${USER}:${PASS}" "${url}")

        if [[ "${j}" == "${empty}" ]]; then
            break
        fi

        jq -r '.[] | "\(.name) - \(.description)\t\(.html_url)"' <<< "${j}"

        page=$(( page +1 ))
    done
}

selected="$(stars|fzf --layout=reverse-list -m -d '	' --with-nth 1)"

if [ -z "${selected}" ]; then
    exit 1
fi

while IFS="	" read -r _ u; do
    qutebrowser "${u}"
done <<< "${selected}"
