#!/usr/bin/env bash

set -euo pipefail

src="${@:1:${#@}-1}"
dest="${*: -1}"

echo "${src} -> ${dest}"

for f in "${@:1:${#@}-1}"; do
    advmv -g "${f}" "${dest}"
    lf -remote 'send load'
    lf -remote 'send clear'
done


