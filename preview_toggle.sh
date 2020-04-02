#!/usr/bin/env bash

if ! pgrep -f ~/.cache/preview_img; then
    exec floater.sh -b sxiv -a -b -g 500x500-10+10 ~/.cache/preview_img
fi|while read p; do
    kill "${p}"
done
