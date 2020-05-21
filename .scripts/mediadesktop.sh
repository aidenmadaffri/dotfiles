#!/bin/bash
if [ -z $(bspc query -D --names | grep Media) ]
then
	touch /tmp/new-desktop.lock
	#Create new desktop, switch to it, and launch jellyfin
	bspc monitor DP-2 -d 1 3 5 7 9 Media
	bspc desktop -f Media
	plexmediaplayer &
	sleep 2
    bspc node -t fullscreen
	rm /tmp/new-desktop.lock
else
	bspc desktop -f Media
fi

