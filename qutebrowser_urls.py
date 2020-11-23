#!/usr/bin/env python

import os

import yaml

try:
    from qutebrowser import qutebrowser, app
    from qutebrowser.misc import ipc
except ImportError:
    print("error: qutebrowser missing.")
    exit(1)


def session_save():
    """Send config-source command to qutebrowsers ipc server."""
    args = qutebrowser.get_argparser().parse_args()
    app.standarddir.init(args)
    socket = ipc._get_socketname(args.basedir)
    ipc.send_to_running_instance(
        socket, [":session-save get_urls"], args.target
    )


session_save()

home = os.environ.get("HOME")
session = os.path.join(home, ".local/share/qutebrowser/sessions/get_urls.yml")

with open(session) as f:
    y = yaml.load(f.read(), Loader=yaml.BaseLoader)

print(y["windows"][0]["tabs"][1]["history"][0]["url"])

for win in y["windows"]:
    for tab in win["tabs"]:
        url = tab["history"][0]["url"]
        title = tab["history"][0]["title"]

        if url.startswith("data:"):
            url = title.split()[-1]
            title = url

        print(url, title)
