#!/usr/bin/env bash

PIPENAME=/tmp/p

[[ -p "${PIPENAME}" ]] || mkfifo "${PIPENAME}"

while :; do
    for i in {31..36}; do
        printf "\e[0;%sm$(date) - $(< "${PIPENAME}")\e[0m\n\n" "${i}"
    done
done
