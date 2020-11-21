#!/usr/bin/env python

import os
import sys

import requests


def main():
    url = os.environ.get("HASS_URL")
    if url is None:
        print("Error: HASS_URL is not set")
        sys.exit(1)

    api_key = os.environ.get("HASS_API_KEY")
    if api_key is None:
        print("Error: HASS_API_KEY is not set")
        sys.exit(1)

    if len(sys.argv) < 2:
        print("Error: pass the name of the switch to toggle")

    entity_id = sys.argv[1]

    headers = {"Authorization": "Bearer {}".format(api_key)}
    data = {"entity_id": entity_id}

    request_url = "{}/api/services/switch/toggle".format(url)

    r = requests.post(request_url, headers=headers, json=data)


if __name__ == "__main__":
    main()
