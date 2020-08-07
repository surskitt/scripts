#!/usr/bin/env zsh

rootdir=/mnt/hd2/Video/Fancams
searchdir=/mnt/hd2/Downloads
edit=false
preview=false
skipgroup=false
auto=false

usage() {
    print -u2 "Usage: ${(%):-%x} -g group -m member [-d rootdir]"
}

while getopts 'ag:m:d:S:G:M:epsl:h' opt; do
  case "$opt" in
    a)
      auto=true
      ;;
    g)
      group="${OPTARG}"
      ;;
    m)
      member="${OPTARG}"
      ;;
    G)
      sgroup="${OPTARG}"
      ;;
    M)
      smember="${OPTARG}"
      ;;
    d)
      rootdir="${OPTARG}"
      ;;
    S)
      searchdir="${OPTARG}"
      ;;
    e)
      edit=true
      ;;
    p)
      preview=true
      ;;
    s)
      skipgroup=true
      ;;
    l)
      logfile="${OPTARG}"
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

$auto && {
    logfile=/tmp/process_fancams_$(date +%Y%m%d_%H%M).log
    for i in ${rootdir}/*;{
        g="${i##*/}"
        for j in ${i}/*;{
            m="${j##*/}"
            [ "${m}" = _group ] && continue

            print "${g} - ${m}"
            $0 -g "${g}" -m "${m}" -l $logfile -S "$searchdir" -d "$rootdir"

            [ -e ${j}/.names ] && {
                while read M; do
                    print "${g} - ${M} (${m})"
                    $0 -g "${g}" -m "${m}" -M "${M}" -l $logfile -S "$searchdir" -d "$rootdir"
                done < ${j}/.names
            }

            [ -e ${i}/.names ] && {
                while read G; do
                    print "${G} (${g}) - ${m}"
                    $0 -g "${g}" -m "${m}" -G "${G}" -l $logfile -S "$searchdir" -d "$rootdir"

                    [ -e ${j}/.names ] && {
                        while read M; do
                            print "${G} (${g}) - ${M} (${m})"
                            $0 -g "${g}" -m "${m}" -G "${G}" -M "${M}" -l $logfile -S "$searchdir" -d "$rootdir"
                        done < ${j}/.names
                    }
                done < ${i}/.names
            }
        }
    }
    exit
}

{ [[ -z ${group} ]] || [[ -z ${member} ]] } && {
    print -u2 "ERROR: group and member arguments are mandatory"
    usage
    exit 1
}

[[ -z ${sgroup} ]] && sgroup="${group}"
[[ -z ${smember} ]] && smember="${member}"
$skipgroup && sgroup=""

found_files=$(find $searchdir \( -iname "*${sgroup}*${smember}*" -o -iname "*${smember}*${sgroup}*" \) -type f)

$preview && {
    mpv --playlist=<(print ${found_files})
}

$edit && {
    editfile=$(mktemp --suffix="${group}_${member}")
    print "${found_files}" > ${editfile}
    $EDITOR ${editfile}
    found_files=$(<${editfile})
}

[[ -z "${found_files}" ]] && { print -u2 "No results found"; exit 1; }

destdir="${rootdir}/${(C)group}/${(C)member}"
mkdir -p ${destdir}

print "Moving $(print ${found_files}|wc -l) files to ${destdir}"
[ -z $logfile ] && [ ! -e $logfile ] && logfile=$(mktemp --suffix=.log)
print "Details can be found in ${logfile}"

print ${found_files}|while read f; do
    filename=${f##*/}
    date=$(print ${filename}|grep -oP "\d{6}")
    stripfilename=$(print ${filename}|sed "s/${sgroup:-iwasnotfound}//gI;s/${smember}//gI;s/${date}//g;s/[()-]//g;s/^ *//"|tr -s ' ')
    newfilename="${(C)group} - ${(C)member} - ${stripfilename}"
    [ ! -z ${date} ] && newfilename="${date} - ${newfilename}"
    print mv "${f}" "${destdir}/${newfilename}" >> ${logfile}
    mv "${f}" "${destdir}/${newfilename}"
done
