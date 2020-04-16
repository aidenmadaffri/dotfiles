#!/bin/bash
if [ -z $(bspc query -D --names | grep Jellyfin) ]
then
	touch /tmp/new-desktop.lock
	#Create new desktop, switch to it, and launch jellyfin
	bspc monitor DP-2 -d 1 3 5 7 9 Jellyfin
	bspc desktop -f Jellyfin
	flatpak run com.github.iwalton3.jellyfin-mpv-shim &
	sleep 5
	rm /tmp/new-desktop.lock
else
	bspc desktop -f Jellyfin
fi
	
