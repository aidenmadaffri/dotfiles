#!/bin/bash
if [ "$PC_TYPE" == "laptop" ]; then
    pulseaudio --daemon
fi
feh --bg-fill --no-fehbg $HOME/Pictures/Wallpapers/wallpaper.png &
redshift &
