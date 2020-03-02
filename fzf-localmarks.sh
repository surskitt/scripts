#!/usr/bin/env bash

FZF_DEFAULT_OPTS="+m --layout=reverse-list"

mark="$(cut -d ':' -f 2 ~/.local/share/ranger/bookmarks|sort -u|fzf)"

find "${mark}" -type f|fzf|while read f; do xdg-open "${f}"; done
