#!/bin/bash
if [ "$PC_TYPE" == "laptop" ]; then
    pulseaudio --daemon
    xautolock -time 5 -corners -000 -locker "screenoff" &
else
    xautolock -time 15 -corners -000 -locker "xset dpms force off" &
fi
feh --bg-fill --no-fehbg $HOME/Pictures/Wallpapers/wallpaper.png &
redshift &
