#!/bin/sh
# a very hacky script for processing notifications
# todo:
# sound crashes Xorg inconsistently
# tmux send-message

notifications="${NOTIFICATIONS:-${XDG_DATA_HOME:-${HOME}/.local/share}/notifications}"
statusbar="${STATUSBAR:-${XDG_DATA_HOME:-${HOME}/.local/share}/statusbar}"
sfx="${SFX:-${XDG_DATA_HOME:-${HOME}/.local/share}/sfx}"


play(){
    mpv --profile=low-latency --volume="${2:-100}" "${sfx}/$1"
}

truncateFile(){
    tmp=$(mktemp /tmp/dunst.XXX)
    tail -n 100 "$1" > "$tmp"
    mv "$tmp" "$1"
}

updateStatusbarMaybePlaySound(){
    count=$(echo "$1" | tr -dc '[:digit:]')
    echo "$2:$count" >> "$statusbar"
    if [ "$count" -gt 0 ]; then
        [ -n "$3" ] && play "$3"
    fi
    truncateFile "$statusbar"
}

case "$1" in
    discord) play "win95/DA_BEEP.WAV" ;;
esac

case "$2" in
    newsboat:*) updateStatusbarMaybePlaySound "$2" feeds "win95/DA_DEFAU.WAV" ;;
    pacman) updateStatusbarMaybePlaySound "$3" pacman "win95/DA_EMPTY.WAV" ;;
    neomutt) updateStatusbarMaybePlaySound "$3" mail "win95/DA_ERROR.WAV" ;;
esac

case "$2" in
    sfx) play "$3" ;;
    *) echo \
        "{
            \"appname\": \"$1\",
            \"summary\": \"$2\",
            \"body\": \"$3\",
            \"icon\": \"$4\",
            \"urgency\": \"$5\"
        }" | jq -c >> "$notifications"
        sleep 10
        echo >> "$notifications"
        truncateFile "$notifications" ;;
esac
