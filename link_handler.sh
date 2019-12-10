#!/usr/bin/env zsh

[ $# -lt 1 ] && print "Usage: $0 URL" && exit 1

URL=$1

(( $+commands[mpv] )) && [[ "$URL" =~ "^(https://)?(www.)?(youtube.com|youtu.be).*" ]] && {
    mpv --fs '--ytdl-format=bestvideo[height<=?720]+bestaudio/best' $URL >/dev/null 2>&1 & 
    exit
}

(( $+commands[mpv] )) && [[ "$URL" =~ "^(https://)giphy.com/*" ]] && {
    mpv --loop ${URL/giphy.com\/embed/media.giphy.com\/media}/giphy.gif >/dev/null 2>&1 &
    exit
}

(( $+commands[feh] )) && [[ "$URL" =~ "(jpg|png|JPG|PNG)(:.*)?$" ]] && {
    feh -A "curl %f -o ~/downloads/pics/%n" $URL >/dev/null 2>&1 &
    exit
}

(( $+commands[mpv] )) && [[ "$URL" =~ "(gif|mp3|GIF|MP3|mp4|MP4)$" ]] && {
    mpv --loop $URL >/dev/null 2>&1 &
    exit
}

(( $+commands[mpv] )) && [[ "$URL" =~ "^(https://)?gfycat.com" ]] && {
    mpv --loop "${URL/gfycat/giant.gfycat}.webm" >/dev/null 2>&1 &
    exit
}

(( $+commands[feh] )) && [[ "$URL" =~ "(https://)?imgur.com/" ]] && {
    feh -A "curl %f -o ~/downloads/pics/%n" ${URL}.png >/dev/null 2>&1 &
    exit
}

$BROWSER $URL >/dev/null 2>&1 &
