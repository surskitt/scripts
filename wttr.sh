#!/usr/bin/env bash

get_icon() {
   case "${*}" in
       *Clear)
           echo 
           ;;
       *Sunny)
           echo 
           ;;
       *Partly\ cloudy)
           echo 杖
           ;;
       *Cloudy)
           echo 
           ;;
       *Overcast)
           echo 
           ;;
       *Mist)
           echo 
           ;;
       *Patchy\ rain\ possible)
           echo 
           ;;
       *Patchy\ snow\ possible)
           echo 
           ;;
       *Patchy\ sleet\ possible)
           echo 
           ;;
       *Patchy\ freezing\ drizzle\ possible)
           echo 
           ;;
       *Thundery\ outbreaks\ possible)
           echo 
           ;;
       *Blowing\ snow)
           echo 
           ;;
       *Blizzard)
           echo 
           ;;
       *Fog)
           echo 
           ;;
       *Freezing\ fog)
           echo 
           ;;
       *Patchy\ light\ drizzle)
           echo 
           ;;
       *Light\ drizzle)
           echo 
           ;;
       *Freezing\ drizzle)
           echo 
           ;;
       *Heavy\ freezing\ drizzle)
           echo 
           ;;
       *Patchy\ light\ rain)
           echo 
           ;;
       *Light\ rain)
           echo 
           ;;
       # Moderate\ rain\ at\ times)
       #     echo
       #     ;;
       # Moderate\ rain)
       #     echo
       #     ;;
       # Heavy\ rain\ at\ times)
       #     echo
       #     ;;
       # Heavy\ rain)
       #     echo
       #     ;;
       # Light\ freezing\ rain)
       #     echo
       #     ;;
       # Moderate\ or\ heavy\ freezing\ rain)
       #     echo
       #     ;;
       # Light\ sleet)
       #     echo
       #     ;;
       # Moderate\ or\ heavy\ sleet)
       #     echo
       #     ;;
       # Patchy\ light\ snow)
       #     echo
       #     ;;
       # Light\ snow)
       #     echo
       #     ;;
       # Patchy\ moderate\ snow)
       #     echo
       #     ;;
       # Moderate\ snow)
       #     echo
       #     ;;
       # Patchy\ heavy\ snow)
       #     echo
       #     ;;
       # Heavy\ snow)
       #     echo
       #     ;;
       # Ice\ pellets)
       #     echo
       #     ;;
       # Light\ rain\ shower)
       #     echo
       #     ;;
       # Moderate\ or\ heavy\ rain\ shower)
       #     echo
       #     ;;
       # Torrential\ rain\ shower)
       #     echo
       #     ;;
       # Light\ sleet\ showers)
       #     echo
       #     ;;
       # Moderate\ or\ heavy\ sleet\ showers)
       #     echo
       #     ;;
       # Light\ snow\ showers)
       #     echo
       #     ;;
       # Moderate\ or\ heavy\ snow\ showers)
       #     echo
       #     ;;
       # Patchy\ light\ rain\ with\ thunder)
       #     echo
       #     ;;
       # Moderate\ or\ heavy\ rain\ with\ thunder)
       #     echo
       #     ;;
       # Patchy\ light\ snow\ with\ thunder)
       #     echo
       #     ;;
       # Moderate\ or\ heavy\ snow\ with\ thunder)
       #     echo
       #     ;;
        *)
           echo "?"
           ;;
   esac
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

w=$(curl -s wttr.in/?format='%c+%C__%t\n')

cond="${w%%__*}"
status="${w##*__}"
icon=$(get_icon "$cond")

if $NOTIFY; then
    notify-send "${cond}" "${status/+/}"
else
    echo "${icon} ${status/+/}"
fi
