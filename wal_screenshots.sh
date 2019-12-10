#!/usr/bin/env bash

#sleep 10; for i in /usr/lib/python3.7/site-packages/pywal/colorschemes/dark/* ~/.config/wal/colorschemes/dark/*;{ j=${i##*/}; t=${j%%.json}; wal -f $t -s; xst -e /home/shane/.scripts/i3tmux.sh & sleep 1; scrot wal_screenshots/dark/${t}.png ; tmux detach -s 3; }
#sleep 1; for i in /usr/lib/python3.7/site-packages/pywal/colorschemes/light/* ~/.config/wal/colorschemes/light/*;{ j=${i##*/ }; t=${j%%.json}; wal -l -f $t -s; xst -e /home/shane/.scripts/i3tmux.sh & sleep 1; scrot wal_screenshots/light/${t}.png ; tmux detach -s 3; }}

for i in /usr/lib/python3.7/site-packages/pywal/colorschemes/dark/*.json ~/.config/wal/colorschemes/dark/*.json; do
    j="${i##*/}"
    t="${j%%.json}"
    wal -f $i -s
    pkill -USR1 xst
    # pkill -USR1 xst
    scrot ~/wal_screenshots_ghosts/dark/${t}.png
done

# for i in /usr/lib/python3.7/site-packages/pywal/colorschemes/light/*.json ~/.config/wal/colorschemes/light/*.json; do
#     echo "${i}"
# done
