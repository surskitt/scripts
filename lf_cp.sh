#!/usr/bin/env bash

set -euo pipefail

echo "cp ${*}"

advcp -r -g "${@}"

lf -remote 'send load'
lf -remote 'send clear'
