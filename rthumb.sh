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
mkdir -p /tmp/rthumb

rsum=$(echo -n "${1}"|sha1sum|cut -d ' ' -f 1)

[ -f "${OUTPUT_DIR}/${rsum}" ] || {
    thumb_file="$(unrar lb "${1}"|egrep 'jpg|png'|sort|head -1)"
    # unzip -o "${1}" -d /tmp "${thumb_file/\[/\\[}"
    # mv "/tmp/${thumb_file}" "${OUTPUT_DIR}/${zsum}"
    # unrar x "${1}" "${thumb_file//\[/\\[}" > "${OUTPUT_DIR}/${zsum}"
    ( cd /tmp/rthumb && unrar x -inul -y "${1}" "${thumb_file}" )
    mv "/tmp/rthumb/${thumb_file}" "${OUTPUT_DIR}/${rsum}"
}

$VERBOSE && echo "${OUTPUT_DIR}/${rsum}"
