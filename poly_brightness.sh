#!/usr/bin/env bash

BRIGHTNESS_STEP=10

notify() {
    script_dir="$(dirname $0)"

    brightness="$(light -G)"
    brightness="${brightness%%\.*}"

    "${script_dir}/poly_notify.sh" " Brightness: $(bar.sh -p ${brightness})"
}

case "${1}" in
  up)
    sudo light -A "${BRIGHTNESS_STEP}"
    ;;
  down)
    sudo light -U "${BRIGHTNESS_STEP}"
    ;;
esac

notify
