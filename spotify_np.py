#!/usr/bin/env python

import sys
import os
import time

import spotipy
import spotipy.util


def get_api_dict(user, client_id, client_secret):
    """ Retrieve an api dictionary with params for spotify client object """
    return {
        'username': user,
        'client_id': client_id,
        'client_secret': client_secret,
        'redirect_uri': 'http://localhost',
        'scope': ' '.join([
            'user-library-read',
            'user-read-currently-playing',
            'user-read-playback-state',
            'user-modify-playback-state',
            'playlist-read-private',
            'playlist-modify-private',
            'playlist-modify-public',
            'playlist-read-collaborative'
        ]),
        'cache_path': os.path.expanduser('~/.cache/sputils/user_cache')
    }


def get_spotify_client(user, client_id, client_secret):
    """ Retrieve a token using api details and return client object """

    api = get_api_dict(user, client_id, client_secret)

    # retrieve token, asking user to auth in browser if necessary
    token = spotipy.util.prompt_for_user_token(**api)
    if not token:
        raise RuntimeError('Unable to retrieve authentication token')

    return spotipy.Spotify(auth=token)


def status(sp):
    track = sp.current_user_playing_track()
    if track is None:
        return '%{F#65737E}'
    if track['is_playing']:
        icon = ''
    else:
        icon = '%{F#65737E}'
    current_track = track['item']
    artist = ', '.join(i['name'] for i in current_track['artists'])
    track = current_track['name']
    #  album = current_track['album']['name']

    #  return f'{icon} {artist} - {track} ({album})'
    return f'{icon} {artist} - {track}'


actions = [
    'tail',
    'status',
    'pause',
    'play',
    'toggle',
    'previous',
    'next'
]

if len(sys.argv) < 2 or sys.argv[1] not in actions:
    print('Error: Supply an argument', file=sys.stderr)
    print('status|pause|play|toggle|previous|next', file=sys.stderr)

action = sys.argv[1]

sp = get_spotify_client(os.getenv('SPOTIFY_USER'),
                        os.getenv('SPOTIFY_CLIENT_ID'),
                        os.getenv('SPOTIFY_CLIENT_SECRET'))

if action == 'tail':
    while True:
        print(status(sp))
        sys.stdout.flush()
        time.sleep(3)

if sp.current_user_playing_track() is None:
    sys.exit()

if action == 'status':
    print(status(sp))

if action == 'pause':
    sp.pause_playback()

if action == 'play':
    sp.start_playback()

if action == 'toggle':
    if sp.current_user_playing_track()['is_playing']:
        sp.pause_playback()
    else:
        sp.start_playback()

if action == 'previous':
    sp.previous_track()

if action == 'next':
    sp.next_track()
