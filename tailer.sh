#!/usr/bin/env bash

SLEEP="${1}"
CMD=${*:2}

$CMD

interrupt() {
    kill $(pgrep -P $$ -x sleep)
}

trap interrupt SIGUSR1

while :; do
    sleep "${SLEEP}" &
    wait $!
    $CMD
done
