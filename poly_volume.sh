#!/usr/bin/env bash

VOLUME_STEP=5

get_icon() {
    case "${1}" in
      mute)
        echo ""
        ;;
      0)
        echo ""
        ;;
      [1-4][0-9]|[0-9])
        echo ""
        ;;
      *)
        echo ""
        ;;
    esac
}

notify() {
    script_dir="$(dirname $0)"
    volume="$(pamixer --get-volume)"

    if pamixer --get-mute >/dev/null ; then
        "${script_dir}/poly_notify.sh" "$(get_icon mute) Volume: muted $(bar.sh ${volume})"
    else
        # volume="$(pamixer --get-volume)"
        icon=$(get_icon "${volume}")
        "${script_dir}/poly_notify.sh" "${icon} Volume:  $(bar.sh -p ${volume})"
    fi
}

case "${1}" in
  up)
    pamixer -i "${VOLUME_STEP}"
    ;;
  down)
    pamixer -d "${VOLUME_STEP}"
    ;;
  mute)
    pamixer -t
    ;;
esac

notify
