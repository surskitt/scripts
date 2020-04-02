#!/usr/bin/env bash

tmpdir="$(mktemp -d)"

qutebrowser -B "${tmpdir}" \
    -s tabs.show never \
    -s statusbar.hide true \
    -s tabs.last_close close \
    "${1}"

rm -rf "${tmpdir}"
