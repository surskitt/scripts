#!/usr/bin/env sh

# if systemctl --user is-active spotifyd >/dev/null 2>&1; then
#     journalctl -n 1 --user -f -o cat --unit spotifyd | while read -r; do
#         playerctl metadata --format '{{ status }} {{ artist }} - {{ title }}'|sed 's/Playing//;s/Paused/%{F#65737E}/;s/Stopped/%{F#65737E}/'
#     done
# else
#     while sleep 1; do playerctl metadata --format '{{ status }} {{ artist }} - {{ title }}'|sed 's/Playing//;s/Paused/%{F#65737E}/;s/Stopped/%{F#65737E}/'; done
# fi

while sleep 3; do playerctl metadata --format '{{ status }} {{ artist }} - {{ title }}'|sed 's/Playing//;s/Paused/%{F#65737E}/;s/Stopped/%{F#65737E}/'; done
