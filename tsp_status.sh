#!/usr/bin/env bash

tsp_out="$(tsp)"

read _ _ _ cmd <<< "$(grep '^[0-9]* *running' <<< ${tsp_out})"

if [[ "${cmd}" == ""  ]]; then
    echo " No tasks running"
    exit
fi

queued=$(grep '^[0-9]* *queued' <<< "${tsp_out}"|wc -l)
count="$((queued+1))"

echo " current task (1 of ${count}): \"${cmd}\""
