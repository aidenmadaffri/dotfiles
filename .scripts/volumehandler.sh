#!/bin/bash
function volUp {
	if playerctl -p clementine status | grep Playing > /dev/null
	then
		playerctl -p clementine volume 0.05+
	else
		$HOME/.scripts/pavolume.sh --up
	fi	
}

function volDown {
	if playerctl -p clementine status | grep Playing > /dev/null
	then
	    playerctl -p clementine volume 0.05-
	else
		$HOME/.scripts/pavolume.sh --down
	fi	
}

case "$1" in
	--up)
		volUp
		;;
	--down)
		volDown
		;;
esac