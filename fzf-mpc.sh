#!/usr/bin/env bash

export TAB="	"

mpc listall -f "[%albumartist%|%artist%] - %album%${TAB}%file%"|while read a; do echo "${a%/*}"; done|sort -u|fzf --layout=reverse-list -m -d "${TAB}" --with-nth 1|cut -d "${TAB}" -f 2|while read s; do mpc add "${s}"; done
