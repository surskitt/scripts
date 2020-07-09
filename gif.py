#!/usr/bin/env python

import os
import sys
import urllib
import tempfile
import hashlib
import subprocess

import requests
import pyperclip

GIF_COUNT = 15

API_BASE = "https://api.tenor.com/v1/search"
api_key = os.environ.get("TENOR_API")

if len(sys.argv) < 2:
    print("Usage: {} <SEARCH TERM>".format(sys.argv[0]))
    sys.exit(1)

search = " ".join(sys.argv[1:])
search_q = urllib.parse.quote(search)

if api_key is None:
    print("Error: TENOR_API not set")
    sys.exit(1)

url = "{}?q={}&key={}&limit={}".format(API_BASE, search_q, api_key, GIF_COUNT)

r = requests.get(url)
rj = r.json()

gif_urls = [i["media"][0]["mp4"]["url"] for i in rj["results"]]


gif_urls = [
    {"gif": i["media"][0]["gif"]["url"], "mp4": i["media"][0]["mp4"]["url"]}
    for i in rj["results"]
]

tmp_dir = tempfile.mkdtemp()

s = requests.Session()

for n, u in enumerate(gif_urls):
    print("downloading {}/{}".format(n + 1, GIF_COUNT))

    r = s.get(u["mp4"])
    fn = os.path.join(tmp_dir, str(n))

    with open(fn, "wb") as f:
        f.write(r.content)

with open(os.devnull, "w") as fnull:
    p = subprocess.call(
        ["mpv", "--fs", tmp_dir], stdout=fnull, stderr=subprocess.STDOUT
    )

selected = sorted(
    (os.path.getatime(i), i)
    for i in [os.path.join(tmp_dir, str(n)) for n in range(GIF_COUNT)]
)[-1][1]

gif_no = int(os.path.basename(selected))
gif_url = gif_urls[gif_no]["gif"]

pyperclip.copy(gif_url)
