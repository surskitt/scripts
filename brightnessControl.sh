#!/usr/bin/env bash

get_icon() {
    # icon_name_template = 'notification-display-brightness-{}.svg'
    # if val == 0:
    #     icon_name = icon_name_template.format('off')
    # if 33 > val > 1:
    #     icon_name = icon_name_template.format('low')
    # if 66 > val > 33:
    #     icon_name = icon_name_template.format('medium')
    # if 100 > val > 66:
    #     icon_name = icon_name_template.format('high')
    # elif val == 100:
    #     icon_name = icon_name_template.format('full')
    case "${1}" in
      0)
        echo "notification-display-brightness-off"
        ;;
      [0-2][0-9])
        echo "notification-display-brightness-low"
        ;;
      [3-6][0-9])
        echo "notification-display-brightness-medium"
        ;;
      [7-9][0-9])
        echo "notification-display-brightness-high"
        ;;
      *)
        echo "notification-display-brightness-full"
        ;;
    esac
    # echo "notification-display-brightness"
}

bar() {
    n=$((${1}/5))
    # n=${1}
    for (( c=1; c<=n; c++ )); do printf '█'; done
    echo
}

notify() {
    brightness="$(light -G)"
    brightness="${brightness%%\.*}"
    icon=$(get_icon "${brightness}")
    dunstify -i "${icon}" -r 2500 -u normal "$(bar "${brightness}")"
}

case "${1}" in
  up)
    sudo light -A 10
    ;;
  down)
    sudo light -U 10
    ;;
esac

notify
