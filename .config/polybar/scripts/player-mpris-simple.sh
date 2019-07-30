#!/bin/sh

player_status=$(playerctl -p clementine status 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    echo " $(playerctl -p clementine metadata title) - $(playerctl -p clementine metadata artist)"
elif [ "$player_status" = "Paused" ]; then
    echo ""
else
    echo ""
fi
