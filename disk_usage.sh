#!/usr/bin/env bash

script_dir="$(dirname $0)"

readarray -t disks <<< "$(df -h|grep '^/dev/'|grep -v '/boot$')"

for i in "${disks[@]}"; do
    read fs size used avail usep mount <<< "${i}"
    d+=(" ${mount}: ${used%G}/${avail} ${usep}")
done

out=$(printf " | %s" "${d[@]}")
echo "${out:3}"
