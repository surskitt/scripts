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


sp = get_spotify_client(os.getenv('SPOTIFY_USER'),
                        os.getenv('SPOTIFY_CLIENT_ID'),
                        os.getenv('SPOTIFY_CLIENT_SECRET'))

devices = sp.devices()['devices']

if len(sys.argv) < 2:
    for device in devices:
        print(device['name'])
else:
    in_device = ' '.join(sys.argv[1:])
    device_id = [i['id'] for i in devices if i['name'] == in_device][0]
    sp.transfer_playback(device_id, force_play=True)
