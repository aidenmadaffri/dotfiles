#!/bin/bash
sleep 0.25
notify-send 'Taking Screenshot...'
FILE_NAME="$(date "+%m-%d_%I:%M:%S_%p").png"
YEAR="$(date "+%Y")"
MONTH="$(date "+%m")"
mkdir -p /home/aiden/Pictures/Screenshots/$YEAR/$MONTH/
maim -s /home/aiden/Pictures/Screenshots/$YEAR/$MONTH/$FILE_NAME ; xclip -selection clipboard -target image/png -i < /home/aiden/Pictures/Screenshots/$YEAR/$MONTH/$FILE_NAME && notify-send 'Screenshot Saved' && exit 0
notify-send 'Screenshot Canceled'