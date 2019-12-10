#!/usr/bin/env bash

if [[ "${#}" -gt 0 ]]; then
    searchterm="${*}"
else
    read -r -p 'search: ' searchterm
fi

# url=$(ddgr -n 25 --np --json "${searchterm}"|jq -c -r '.[]|[ .url, .title, .abstract ]|@tsv'|fzf -d '	' --with-nth=2,3 --layout=reverse-list|cut -d '	' -f 1)
url=$(ddgr -n 25 --np --json "${searchterm}"|jq -c -r '.[]|[ .url, .title ]|@tsv'|fzf -m -d '	' --with-nth=2,3 --layout=reverse-list|cut -d '	' -f 1)

[ -n "${url}" ] && {
    while read -r u; do
        xdg-open "${u}" 
    done <<< "${url}"
}
