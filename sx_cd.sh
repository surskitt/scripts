#!/usr/bin/env bash

if [ "${#}" -eq 0 ]; then
    searchdir="${PWD}"
else
    searchdir="${1}"
fi

thumb=$(sxiv -fto "${searchdir}"/*/.folder.jpg|head -1)
echo "${thumb}"

dir="${thumb%/*}"
echo "${dir}"

cd "${dir}"

${SHELL}
