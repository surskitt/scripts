#!/usr/bin/env bash

declare -A metadata

while read -r _ key val; do
    metadata[$key]=$val
done < <(playerctl -p spotifyd metadata)

body="${metadata[xesam:albumArtist]}
${metadata[xesam:album]}"

notify-imgurl.sh "${metadata[mpris:artUrl]}" "${metadata[xesam:title]}" "${body}"
