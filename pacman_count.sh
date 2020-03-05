#!/usr/bin/env bash

count="$(pacman -Supq|wc -l)"

echo " ${count} new packages"
