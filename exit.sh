#!/bin/sh
lock() {
    lxdm -c USER_SWITCH
}

pre_exit() {
    killall mopidy
    while [ ! -e ~/.local/share/mopidy/core/state.json.gz ] ; do
        sleep 1
    done
}

case "$1" in
    lock)
        light-locker-command -l
        ;;
    logout)
        pre_exit
        bspc quit
        ;;
    suspend)
        systemctl suspend
        ;;
    hibernate)
        systemctl hibernate
        ;;
    reboot)
        pre_exit
        systemctl reboot
        ;;
    shutdown)
        pre_exit
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
