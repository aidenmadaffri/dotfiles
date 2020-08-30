#!/bin/bash
nextcloud --background &
killall emacs
killall emacsclient
emacs --daemon &
if [ "$PC_TYPE" == "desktop" ]; then
    xss-lock -- slock &
    steam &
    thunderbird &
    discord &
    kitty --class startupterm1 &
    kitty --class startupterm2 &
    $BROWSER &
    sleep 1
    $BROWSER &
    sleep 1
    xsetroot -name "fsignal:2"
    sleep 0.5
    xsetroot -name "fsignal:1"
else
    $BROWSER &
fi
