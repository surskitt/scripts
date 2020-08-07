#!/usr/bin/env bash

p=$(previewer.sh "${*}")

timeout 1.5 floater.sh -b sxiv -a -b -g 500x280-10+10 "${p}"
# timeout 1.5 sxiv -a -b -g 500x280-10+10 "${p}"
