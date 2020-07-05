#!/bin/bash
bspc subscribe | while read line; do
	#Grab status of "Jellyfin" desktop
	status=$(echo $line | rg -o '^.+([oOfF])Media.*$' -r '$1')
	#If jellyfin is closed, return to original desktop configuration
	if [ "$status" = "F" ] || [ "$status" = "f" ]
	then
		[ ! -f /tmp/new-desktop.lock ] && bspc desktop -f 1 && bspc monitor DP-2 -d 1 2 3 4 5 && xautolock -time 15 -locker "/home/aiden/.scripts/screenoff.sh" &
	fi
done
