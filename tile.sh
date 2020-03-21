#!/usr/bin/env bash

mapfile -t curr_desktops < <(bspc query -D -d '.active')
focused_desktop=$(bspc query -D -d '.focused')

if [[ "${#}" -gt 18 ]]; then
    echo "Error: only supports 18 vids or less"
    exit 1
fi

# close window on desktops 7 and 8
(bspc query -N -d files; bspc query -N -d files2)|while read -r n; do
    bspc node "${n}" -c
done

bspc desktop -f files2
bspc desktop -f files

pids=()
for i in "${@}"; do
    mimetype=$(file -L -b --mime-type "${i}")
    case "${mimetype}" in
        image/jpeg)
            feh "${i}" &
            ;;
        video/mp4|video/webm|video/3gpp|video/x-flv|video/x-matroska|video/x-msvideo)
            mpv --quiet --mute --force-window=immediate "${i}" >&2 >/dev/null &
            ;;
    esac
    pids+=($!)
done

echo "waiting for windows to launch..."
sleep 1

desktop=files
bspc query -N -d files -n '.window'|while read -r n; do 
    echo "moving ${n} to ${desktop}"
    bspc node "${n}" -d "${desktop}"

    echo "tiling ${n}"
    bspc node "${n}" -t tiled

    [[ "${desktop}" == files ]] && desktop=files2 || desktop=files
done

sleep 1
for d in files files2; do
    # n=$(bspc query -N -d "${d}" -n '.window'|wc -l)
    mapfile -t ns < <(bspc query -N -d "${d}" -n '.window')
    case "${#ns[@]}" in
        1|2)
            ;;
        3)
            bspc node "${ns[0]}" -o 0.333
            bspc node "${ns[1]}" -n "${ns[0]}"
            bspc node "${ns[1]}" -o 0.5
            bspc node "${ns[2]}" -n "${ns[1]}"
            ;;
        4)
            bspc node "${ns[0]}" -o 0.5 -p south
            bspc node "${ns[1]}" -n "${ns[0]}"
            bspc node "${ns[2]}" -o 0.5 -p south
            bspc node "${ns[3]}" -n "${ns[2]}"
            ;;
        5)
            ;;
        6)
            ;;
        7)
            ;;
        8)
            ;;
        9)
            bspc node "${ns[0]}" -o 0.333 -p south
            bspc node "${ns[1]}" -n "${ns[0]}"
            bspc node "${ns[1]}" -o 0.5 -p south
            bspc node "${ns[2]}" -n "${ns[1]}"
            sleep 1
            bspc node "${ns[3]}" -o 0.333 -p south
            bspc node "${ns[4]}" -n "${ns[3]}"
            bspc node "${ns[4]}" -o 0.5 -p south
            bspc node "${ns[5]}" -n "${ns[4]}"
            sleep 1
            bspc node "${ns[6]}" -o 0.333 -p south
            bspc node "${ns[7]}" -n "${ns[6]}"
            bspc node "${ns[7]}" -o 0.5 -p south
            bspc node "${ns[8]}" -n "${ns[7]}"
            sleep 1
            ;;
    esac

done

polybar-msg cmd hide; sleep 0.1; bspc config bottom_padding 0
bspc config window_gap 0

while :; do
    if [[ $(ps --no-headers -fp "${pids[@]}" 2>/dev/null|wc -l) -eq 0 ]]; then break; fi
    sleep 1
done

polybar-msg cmd show; sleep 0.1; bspc config bottom_padding 27
bspc config window_gap 50

for d in "${curr_desktops[@]}"; do
    bspc desktop -f "${d}"
done
bspc desktop -f "${focused_desktop}"
