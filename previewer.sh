#!/usr/bin/env bash

w="iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAABhWlDQ1BJQ0MgcHJvZmlsZQAAKJF9
kT1Iw1AUhU9TiyIVFTuIOGSoThZERRy1CkWoEGqFVh1MXvoHTRqSFBdHwbXg4M9i1cHFWVcHV0EQ
/AFxcnRSdJES70sKLWK88Hgf591zeO8+QKiXmWZ1jAOabpupRFzMZFfFzlcE0Y8A+hCSmWXMSVIS
vvV1T51UdzGe5d/3Z/WoOYsBAZF4lhmmTbxBPL1pG5z3iSOsKKvE58RjJl2Q+JHrisdvnAsuCzwz
YqZT88QRYrHQxkobs6KpEU8RR1VNp3wh47HKeYuzVq6y5j35C8M5fWWZ67SGkcAiliBBhIIqSijD
Rox2nRQLKTqP+/iHXL9ELoVcJTByLKACDbLrB/+D37O18pMTXlI4DoReHOdjBOjcBRo1x/k+dpzG
CRB8Bq70lr9SB2Y+Sa+1tOgR0LsNXFy3NGUPuNwBBp8M2ZRdKUhLyOeB9zP6piwwcAt0r3lza57j
9AFI06ySN8DBITBaoOx1n3d3tc/t357m/H4A0zRyZ7fkKMUAAAAJcEhZcwAALiMAAC4jAXilP3YA
AAAHdElNRQfkAxEBEBsvYQiUAAAAGXRFWHRDb21tZW50AENyZWF0ZWQgd2l0aCBHSU1QV4EOFwAA
AAxJREFUCNdj+P//PwAF/gL+3MxZ5wAAAABJRU5ErkJggg=="

ww() {
    mkdir -p ~/.thumbnails/misc
    if [ ! -f ~/.thumbnails/misc/w.png ]; then
        echo "${w}"|base64 -d > ~/.thumbnails/misc/w.png
    fi
}

sum() {
    echo -n "${1}"|sha1sum|cut -d ' ' -f 1
}

misc_handler() {
    ww
    fs=$(sum "${1}")
    fsn=~/.thumbnails/misc/${fs}
    if [ ! -e "${fsn}" ]; then
        ln -sf ~/.thumbnails/misc/w.png "${fsn}"
    fi
    echo "${fsn}"
}

if [ ${#} -lt 1 ]; then
    echo "Usage: ${0} fn" >&2
    exit 1
fi

mime=$(file -L -b --mime-type "${1}")

# cached="$(kv.sh get ${1} ~/.thumbnails/kv.tsv 2>/dev/null)"

# if [[ "${cached}" != "" ]]; then
#     echo "${cached}"
#     exit
# fi

MISC_ICON="/usr/share/icons/Surfn-Arc/places/128/desktop.png"

case "${mime}" in
    image/*)
        out="${1}"
        ;;
    video/*)
        out=$(vthumb.sh -v "${1}" 2>/dev/null)
        ;;
    inode/directory)
        # if ls "${1}/".folder 2>/dev/null; then
        if [ -f "${1}/.folder" ]; then
            out="${1}/.folder"
        else
            out="${MISC_ICON}"
        fi
        ;;
    application/zip)
        out=$(zthumb.sh -v "${1}")
        ;;
    application/x-rar)
        out=$(rthumb.sh -v "${1}")
        ;;
    *)
        out="${MISC_ICON}"
        ;;
esac

# kv.sh put "${1}" "${out}" ~/.thumbnails/kv.tsv
echo "${out}"
