#!/usr/bin/env bash

${@:2}

while sleep "${1}"; do
    ${@:2}
done
