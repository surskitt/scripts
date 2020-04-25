#!/usr/bin/env bash

book="$(/usr/lib/calibre/bin-py2/calibredb list -f title,authors,formats --for-machine|calibrefilter.py|fzf -d '	' --with-nth=1|cut -d '	' -f 2)"

if [ -z "${book}" ]; then
    exit 1
fi

nohup zathura "${book}" &
disown
