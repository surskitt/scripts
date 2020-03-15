#!/usr/bin/env bash

batinfo=$(upower -i $(upower -e|grep BAT))

time=$(grep -E -o '[0-9\.]* hours|[0-9\.]* minutes' <<< "${batinfo}")
percent=$(grep -o '[0-9\.]*%' <<< "${batinfo}"|head -1)

if grep -q "time to empty" <<< "${batinfo}"; then
    status="until empty"
else
    status="until full"
fi

if [[ "${percent}" == "100%" && "${status}" == "until full" ]]; then
    echo "⏻ battery full"
    exit
fi

echo "⏻ battery ${percent} - ${time} ${status}"
