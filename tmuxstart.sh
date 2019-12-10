#!/usr/bin/env bash

get_active() {
    wmctrl -d|while read -r _ active _ _ _ _ _ _ name; do
        if [ "${active}" = '*' ]; then
            echo "${name}"
        fi
    done
}

session_count() {
    local workspace="${1}"

    read -r name count <<< "$(tmux ls -F '#S #{session_attached}'|grep "${workspace}")"
    echo "${count:-0}"
}

get_next() {
    workspace="${1}"

    if [ "$(session_count "${workspace}")" = 0 ]; then
        echo "${workspace}"
    else
        if [[ "${workspace}" = *_[0-9] ]]; then
            name="${workspace%_*}"
            n="${workspace##*_}"
            n=$((n+1))
        else
            name="${workspace}"
            n=2
        fi
        get_next "${name}_${n}"
    fi

}


workspace="$(get_active)${1}"
next="$(get_next "${workspace}")"

tmux new-session -s "${next}" -n ' ' || tmux attach -t "${next}"
