#!/usr/bin/env bash

get_icon() {
   case "${*}" in
       Clear)
           echo 
           ;;
       Sunny)
           echo 
           ;;
       Partly\ cloudy)
           echo 杖
           ;;
       Cloudy)
           echo 
           ;;
       Overcast)
           echo 
           ;;
       Mist)
           echo 
           ;;
       Patchy\ rain\ possible)
           echo 
           ;;
       Patchy\ snow\ possible)
           echo 
           ;;
       Patchy\ sleet\ possible)
           echo 
           ;;
       Patchy\ freezing\ drizzle\ possible)
           echo 
           ;;
       Thundery\ outbreaks\ possible)
           echo 
           ;;
       Blowing\ snow)
           echo 
           ;;
       Blizzard)
           echo 
           ;;
       Fog)
           echo 
           ;;
       Freezing\ fog)
           echo 
           ;;
       Patchy\ light\ drizzle)
           echo 
           ;;
       Light\ drizzle)
           echo 
           ;;
       Freezing\ drizzle)
           echo 
           ;;
       Heavy\ freezing\ drizzle)
           echo 
           ;;
       Patchy\ light\ rain)
           echo 
           ;;
       Light\ rain)
           echo 
           ;;
       Moderate\ rain\ at\ times)
           echo 
           ;;
       Moderate\ rain)
           echo 
           ;;
       Heavy\ rain\ at\ times)
           echo 
           ;;
       Heavy\ rain)
           echo 
           ;;
       Light\ freezing\ rain)
           echo 
           ;;
       Moderate\ or\ heavy\ freezing\ rain)
           echo 
           ;;
       Light\ sleet)
           echo 
           ;;
       Moderate\ or\ heavy\ sleet)
           echo 
           ;;
       Patchy\ light\ snow)
           echo 流
           ;;
       Light\ snow)
           echo 流
           ;;
       Patchy\ moderate\ snow)
           echo 流
           ;;
       Moderate\ snow)
           echo 流
           ;;
       Patchy\ heavy\ snow)
           echo 
           ;;
       Heavy\ snow)
           echo 
           ;;
       Ice\ pellets)
           echo 
           ;;
       Rain\ shower)
           echo 
           ;;
       Light\ rain\ shower)
           echo 
           ;;
       Moderate\ or\ heavy\ rain\ shower)
           echo 
           ;;
       Torrential\ rain\ shower)
           echo 
           ;;
       Light\ sleet\ showers)
           echo 
           ;;
       Moderate\ or\ heavy\ sleet\ showers)
           echo 
           ;;
       Light\ snow\ showers)
           echo 
           ;;
       Moderate\ or\ heavy\ snow\ showers)
           echo 
           ;;
       Patchy\ light\ rain\ with\ thunder)
           echo 
           ;;
       Moderate\ or\ heavy\ rain\ with\ thunder)
           echo 
           ;;
       Patchy\ light\ snow\ with\ thunder)
           echo 
           ;;
       Moderate\ or\ heavy\ snow\ with\ thunder)
           echo 
           ;;
        Drizzle\ and\ rain)
           echo 
           ;;
        *)
           echo "?"
           ;;
   esac
}

notify_body() {
    humidity="${1}"
    wind="${2}"
    sunrise="${3}"
    dawn="${4}"
    sunset="${5}"
    dusk="${6}"

    l1="💧 ${humidity/\\/}"
    l2="🌬️ ${wind}"
    l3="🌅 ${sunrise%:*} (${dawn%:*})"
    l4="🌇 ${sunset%:*} (${dusk%:*})"

    printf "\n%s\n%s\n%s\n%s\n" "${l1}" "${l2}" "${l3}" "${l4}"
}

NOTIFY=false

while getopts "n" opt; do
    case "${opt}" in
        n)
            NOTIFY=true
            ;;
        ?)
            echo "Invalid options passed"
            exit 1
            ;;
    esac
done

w=$(curl -s wttr.in/?format='%c_%C_%t_%h_%w_%S_%D_%s_%d\n')

IFS="_" read -r emoji cond temp humidity wind sunrise dawn sunset dusk <<< "${w}"

icon=$(get_icon "$cond")

if $NOTIFY; then
    title="${emoji} ${cond} ${temp#+}"
    body=$(notify_body "${humidity}" "${wind}" "${sunrise}" "${dawn}" "${sunset}" "${dusk}")

    notify-send "${title}" "${body}"
else
    echo "${icon} ${temp/+/}"
fi
