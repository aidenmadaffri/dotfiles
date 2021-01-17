#!/bin/sh
FILE_NAME="$(date "+%m-%d_%I:%M:%S_%p").png"
YEAR="$(date "+%Y")"
MONTH="$(date "+%m")"
mkdir -p /Users/aiden/Nextcloud/Pictures/Screenshots/$YEAR/$MONTH/
PATH=/Users/aiden/Nextcloud/Pictures/Screenshots/$YEAR/$MONTH/$FILE_NAME
/usr/sbin/screencapture -i $PATH
/usr/bin/osascript -e 'set the clipboard to "'$PATH'"'
