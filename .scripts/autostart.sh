#!/bin/bash
swaymsg "workspace 3"
alacritty &
sleep 1
swaymsg "workspace 8"
alacritty &
sleep 1
swaymsg "workspace 6"
firefox &
sleep 3
swaymsg "workspace 1"
firefox &
