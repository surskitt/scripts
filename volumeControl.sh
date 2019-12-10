#!/usr/bin/env bash

get_icon() {
    case "${1}" in
      mute)
        echo "notification-audio-volume-muted"
        ;;
      0)
        echo "notification-audio-volume-off"
        ;;
      [1-4][0-9]|[0-9])
        echo "notification-audio-volume-low"
        ;;
      [5-9][0-9])
        echo "notification-audio-volume-medium"
        ;;
      *)
        echo "notification-audio-volume-high"
        ;;
    esac
}

bar() {
    n=$((${1}/5))
    for (( c=1; c<=n; c++ )); do printf '█'; done
    echo
}


notify() {
    if pamixer --get-mute >/dev/null ; then
        dunstify -i "$(get_icon mute)" -r 2400 -u normal "Volume muted"
    else
        volume="$(pamixer --get-volume)"
        icon=$(get_icon "${volume}")
        # dunstify -i "${icon}" -r 2400 -u normal "${volume//100/+}   $(bar "${volume}")"
        dunstify -i "${icon}" -r 2400 -u normal "$(bar "${volume}")"
    fi
}


case "${1}" in
  up)
    pamixer -i 5
    ;;
  down)
    pamixer -d 5
    ;;
  mute)
    pamixer -t
    ;;
esac

notify
