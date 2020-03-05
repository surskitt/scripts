#!/usr/bin/env bash

export TS_SOCKET=/tmp/socket-ts.yt
script_dir="$(dirname $0)"

tsp_out="$(tsp)"

if ! grep -q '^[0-9]* *running' <<< "${tsp_out}"; then
    echo " No youtube downloads running"
    exit
fi

queued=$(grep '^[0-9]* *queued' <<< "${tsp_out}"|wc -l)
count="$((queued+1))"

yf=$(<$(tsp -o))

if ! grep -q 100% <<< "${yf}"; then
    stream=video
else
    stream=audio
fi

progress=$(grep -o '[0-9\.]*%' <<< "${yf}"|tail -1)
if [[ "${progress}" == "" ]]; then
    progress=0.0%
fi

bar=$("${script_dir}/bar.sh" "${progress%\.*}")
dl=$(grep '\[download\] \(Destination\):' <<< "${yf}")
fn="${dl##*/}"

echo " Downloading \"${fn}\" ${stream} (1 of ${count}): ${progress} ${bar}"
