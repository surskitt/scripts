#!/usr/bin/env bash

POLYBAR_CONFIG="${HOME}/.config/polybar/config"
NOTIFY_LENGTH=3

cmd="${1}"
args="${@:2}"

mr=$(grep modules-right "${POLYBAR_CONFIG}")

echo "${args}" >> /tmp/polybar_notify

sed -i "s/modules-right.*/modules-right = notify/" "${POLYBAR_CONFIG}"

sleep "${NOTIFY_LENGTH}"

sed -i "s/modules-right.*/${mr}/" "${POLYBAR_CONFIG}"
