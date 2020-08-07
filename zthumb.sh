#!/usr/bin/env bash

OUTPUT_DIR=~/.thumbnails/zips
VERBOSE=false
while getopts 'vo:h' opt; do
  case "$opt" in
    o)
      OUTPUT_DIR="${OPTARG}"
      ;;
    v)
      VERBOSE=true
      ;;
    h)
      usage
      exit
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done
shift $(( OPTIND - 1 ))

mkdir -p "${OUTPUT_DIR}"

zsum=$(echo -n "${1}"|sha1sum|cut -d ' ' -f 1)

[ -f "${OUTPUT_DIR}/${zsum}" ] || {
    thumb_file="$(unzip -Z1 "${1}"|egrep 'jpg|png'|sort|head -1)"
    # unzip -o "${1}" -d /tmp "${thumb_file/\[/\\[}"
    # mv "/tmp/${thumb_file}" "${OUTPUT_DIR}/${zsum}"
    unzip -p -q "${1}" "${thumb_file//\[/\\[}" > "${OUTPUT_DIR}/${zsum}"
}

$VERBOSE && echo "${OUTPUT_DIR}/${zsum}"
