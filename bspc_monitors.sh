#!/usr/bin/env bash

if [[ "${#}" -lt 1  || "${#}" -gt 3 ]]; then
    echo "Error: Provide between 1 and 3 arguments" >&2
    exit 1
fi

for i in "${@}"; do
    if [[ "${i}" -lt 1 || "${i}" -gt 3 ]]; then
        echo "Error: only pass arguments between 1 and 3" >&2
        exit 1
    fi
done

if [[ "$(bspc query -M|wc -l)" -lt "${#}" ]]; then
    echo "Error: number of arguments is less than the number of monitors" >&2
    exit 1
fi

clear_empties() {
    for i in {1..3}; do
        bspc query -D -d "empty_${i}" >/dev/null 2>&1 && bspc desktop "empty_${i}" -r
    done
}

one_mon() {
    bspc monitor "${2}" -a "empty_2"
    bspc monitor "${3}" -a "empty_3"

    for i in  internet coding chat music video books files files2 files3 windows; do
       bspc desktop "${i}" -m "${1}"
    done

    clear_empties
}

two_mon() {
    bspc monitor "${3}" -a "empty_3"

    for i in internet video books files; do
        bspc desktop "${i}" -m "${1}"
    done

    for i in coding chat music files2 files3 windows; do
        bspc desktop "${i}" -m "${2}"
    done

    clear_empties
}

three_mon() {
    for i in internet files books; do
        bspc desktop "${i}" -m "${1}"
    done

    for i in coding files2; do
        bspc desktop "${i}" -m "${2}"
    done

    for i in chat music video files3 windows; do
        bspc desktop "${i}" -m "${3}"
    done

    clear_empties
}

nodes="$(bspc query -D --names|while read -r d; do bspc query -N -d ${d}|while read -r n; do echo "${d} ${n}"; done; done)"

mapfile -t monitors <<< "$(bspc query -M --names)"
monitors=(0 "${monitors[@]}")

othermons=()
for i in {1..3}; do
    if [[ "${*}" != *${i}* ]]; then
        othermons+=("${i}")
    fi
done

case "${#}" in
    1)
        one_mon "${monitors[${1}]}" "${monitors[${othermons[0]}]}" "${monitors[${othermons[1]}]}"
        ;;
    2)
        two_mon "${monitors[${1}]}" "${monitors[${2}]}" "${monitors[${othermons[0]}]}"
        ;;
    3)
        three_mon "${monitors[${1}]}" "${monitors[${2}]}" "${monitors[${3}]}"
        ;;
esac

while read -r d n; do
    bspc node "${n}" -d "${d}"
done <<< "${nodes}"
