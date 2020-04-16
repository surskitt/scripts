#!/usr/bin/env bash

STATUS_TRUNC=50

cleanup() {
    echo
    pkill -P $$ playerctl
    echo "Cleaning up files" >&2
    rm -f /tmp/playerctl_tail
    rm -f /tmp/playerctl_pipe
}

usage() {
    echo "Usage: $0 [daemon|play|pause|play-pause|status|info|tail|switch]"
}

player=spotify

player_icon() {
    case "${1}" in
        spotify)
            echo 
            ;;
        pocket_casts_linux)
            echo 
            ;;
        chromium*)
            echo 
            ;;
        mpv)
            echo 
            ;;
        *)
            echo 
            ;;
    esac
}

next_player() {
    players=($(playerctl -l|grep -v chromium))

    for i in "${!players[@]}"; do
        if [[ "${players[$i]}" = "${player}" ]]; then
            player_id="${i}";
        fi
    done

    if [ -z "${player_id}" ]; then
        player="${players[0]}"
    else
        if [ "${player_id}" = "$((${#players[@]}-1))" ]; then
            player="${players[0]}"
        else
            player="${players[player_id+1]}"
        fi
    fi
}

daemon_run() {
    pformat="$(player_icon $player) {{ artist }} - {{ title }}"
    playerctl -p "${player}" metadata --format "${pformat}" --follow >> /tmp/playerctl_tail
}

daemon_running() {
    [[ -f /tmp/playerctl_tail || -p /tmp/playerctl_pipe ]]
}

pause_others() {
    playerctl -l|grep -v "${player}"|grep -v chromium|while read p; do
        playerctl -p "${p}" pause
    done
    if [[ "${player}" != pocket_casts_linux && "$(playerctl -p pocket_casts_linux status)" == "Playing" ]]; then
        playerctl -p "${p}" play-pause
    fi
}

if [ $# -lt 1 ]; then
    usage >&2
    exit 1
fi

cmd="${1}"

case "${cmd}" in
    daemon)
        trap "cleanup" SIGKILL
        trap "cleanup" SIGINT
        trap "cleanup" EXIT

        if daemon_running; then
            echo "Daemon is already running" >&2
            exit 1
        fi

        daemon_run &

        mkfifo /tmp/playerctl_pipe
        tail -f /tmp/playerctl_pipe | while read pcmd; do
            case "${pcmd}" in
                switch)
                    next_player
                    pkill -P $$ playerctl
                    daemon_run &
                    ;;
                play|pause|play-pause|previous|next)
                    playerctl -p "${player}" "${pcmd}"
                    pause_others
                    ;;
                *)
                    ;;
            esac
        done
        ;;
    switch|play|pause|previous|next|play-pause)
        daemon_running || echo "daemon is not running" >&2

        echo "${cmd}" > /tmp/playerctl_pipe
        ;;
    status)
        daemon_running || echo "daemon is not running" >&2

        tail -1 /tmp/playerctl_tail
        ;;
    tail)
        daemon_running || echo "daemon is not running" >&2

        tail -f /tmp/playerctl_tail
        ;;
    info)
        echo "Controlling ${player}"
        ;;
    *)
        usage >&2
        exit 1
        ;;
esac
