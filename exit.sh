#!/bin/sh
lock() {
    lxdm -c USER_SWITCH
}

case "$1" in
    lock)
        light-locker-command -l
        ;;
    logout)
        bspc quit
        ;;
    suspend)
        systemctl suspend
        ;;
    hibernate)
        systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
