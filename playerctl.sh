#!/usr/bin/env sh

while sleep 1; do playerctl metadata --format '{{ status }} {{ artist }} - {{ title }}'|sed 's/Playing//;s/Paused/%{F#65737E}/;s/Stopped/%{F#65737E}/'; done
