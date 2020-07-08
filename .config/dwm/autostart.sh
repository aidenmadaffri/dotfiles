#!/bin/bash
xss-lock -- slock &
nextcloud --background &
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
