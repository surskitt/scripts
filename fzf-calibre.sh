#!/usr/bin/env bash

book="$(/usr/lib/calibre/bin-py2/calibredb list -f title,authors,formats,*tags --for-machine --sort-by title --ascending|calibrefilter.py|fzf -d '	' --layout=reverse-list --with-nth=1|cut -d '	' -f 2)"

if [ -z "${book}" ]; then
    exit 1
fi

nohup zathura "${book}" &
disown
