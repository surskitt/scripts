#!/usr/bin/env sh

i3_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')${1}

tmux new-session -s $i3_workspace -n ' ' || tmux attach -t $i3_workspace
