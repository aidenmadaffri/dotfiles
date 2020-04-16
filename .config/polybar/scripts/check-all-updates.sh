#!/bin/sh
#source https://github.com/x70b1/polybar-scripts


if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

# if ! updates_aur=$(cower -u 2> /dev/null | wc -l); then
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    if ! updates_aur=$(yay -Qum | wc -l); then
        updates_aur=0
    fi
fi


echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    updates=$(("$updates_arch" + "$updates_aur"))
else
    echo "No Internet"
    exit
fi


if [ "$updates" -gt 0 ]; then
    echo " $updates"
else
    echo "0"
fi
