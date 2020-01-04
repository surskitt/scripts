#!/usr/bin/env python

import gi

gi.require_version('Playerctl', '2.0')

from gi.repository import Playerctl

player = gi.repository.Playerctl.Player()


def on_play(player, status):
    print(f' {player.get_artist()}')

player.connect('playback-status::playing', on_play)

#  while sleep 3; do playerctl metadata --format '{{ status }} {{ artist }} - {{ title }}'|sed 's/Playing//;s/Paused/%{F#65737E}/;s/Stopped/%{F#65737E}/'; done
