#!/usr/bin/env bash

# n="${1}"
PERCENT=false

while [[ $# -gt 0 ]]; do
    case "${1}" in
        -p|--percent)
            PERCENT=true
            ;;
        *)
            n=${1}
            ;;
    esac
    shift 1
done

nre='^[0-9]+$'
if [[ ! ${n} =~ $nre || "${n}" -gt 100 ]]; then
    exit 1
fi

bar() {
    printf '|'
    count=$((${1}/5))
    bg=$((20-${count}))
    if [[ ${count} -ne 0 ]]; then
        printf '─%.0s' $(seq 1 ${count})
    fi
    if [[ ${count} -ne 20 ]]; then
        printf ' %.0s' $(seq 1 ${bg})
    fi
    echo '|'
}

pad() {
    printf '%3s' "${1}"
    echo
}

if "${PERCENT}"; then
    echo -n "$(pad ${n})% "
fi

echo "$(bar ${n})"
