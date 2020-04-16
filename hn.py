#!/usr/bin/env python

import sys
import argparse
import urllib.request
import json
import concurrent.futures

STORY_COUNT = 50
WORKERS = 50
STORIES_URL = 'https://hacker-news.firebaseio.com/v0/topstories.json'
STORY_URL_TMPL = 'https://hacker-news.firebaseio.com/v0/item/{}.json'


def parse_args(args):
    desc = 'Pull stories from hacker news'
    parser = argparse.ArgumentParser(description=desc)

    parser.add_argument('-f', '--format', type=str, default='{id} {title}')

    args = parser.parse_args(args)
    return args


def story_download(id):
    story_url = STORY_URL_TMPL.format(id)

    return json.loads(urllib.request.urlopen(story_url).read())


def main():
    args = parse_args(sys.argv[1:])

    ids = json.loads(urllib.request.urlopen(STORIES_URL).read())[:STORY_COUNT]

    with concurrent.futures.ThreadPoolExecutor(WORKERS) as executor:
        story_map = executor.map(story_download, ids)

    for s in story_map:
        print(args.format.format(**s))


if __name__ == "__main__":
    main()
