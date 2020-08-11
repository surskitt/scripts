#!/usr/bin/env bash

usage() {
    echo "kv.sh get KEY FILE"
    echo "kv.sh put KEY VAL FILE"
}

cmd="${1}"

if ! [[ "${cmd}" =~ ^(get|put)$ ]]; then
    echo "Error: cmd must be one of \"get\" or \"put\"" >&2
    echo >&2
    usage >&2
    exit 1
fi

TAB="	"

if [[ "${cmd}" == "get" ]]; then
    key="${2}"
    f="${3}"

    if [[ "${key}" == "" ]]; then
        echo "Error: no key passed" >&2
        echo >&2
        usage >&2
        exit 1
    fi

    if [[ "${f}" == "" ]]; then
        echo "Error: no file passed" >&2
        echo >&2
        usage >&2
        exit 1
    fi

    if ! [ -f "${f}" ]; then
        echo "Error: ${f} does not exist" >&2
        exit 1
    fi

    if [[ $(file -b --mime-type "${f}") != "text/plain" ]]; then
        echo "Error: ${f} is not a text file"
        exit 1
    fi

    val=$(grep "^${key}${TAB}" "${f}" 2>/dev/null|cut -d "${TAB}" -f 2)

    if [[ "${val}" == "" ]]; then
        echo "Error: key ${key} not found" >&2
        exit 1
    fi

    echo "${val}"
else
    key="${2}"
    val="${3}"
    f="${4}"

    if [[ "${key}" == "" ]]; then
        echo "Error: no key passed" >&2
        echo >&2
        usage >&2
        exit 1
    fi

    if [[ "${val}" == "" ]]; then
        echo "Error: no val passed" >&2
        echo >&2
        usage >&2
        exit 1
    fi

    if [[ "${f}" == "" ]]; then
        echo "Error: no file passed" >&2
        echo >&2
        usage >&2
        exit 1
    fi

    if ! [ -f "${f}" ]; then
        touch "${f}"
    fi

    if ! [[ $(file -b --mime-type "${f}") =~ ^(text/plain|empty|inode/x-empty)$ ]]; then
        echo "Error: ${f} is not a text file"
        exit 1
    fi

    content=$(grep -v "^${key}${TAB}" "${f}")

    cat <<-EOF > "${f}"
	${content}
	${key}${TAB}${val}
	EOF
fi
