#!/bin/bash

sleep 0.5
xset dpms force off
if [[ "`pidof -x $(basename $0) -o %PPID`" ]]; then exit; fi
echo active > /dev/input/ckb1/cmd
sleep 0.1
echo rgb 000000 > /dev/input/ckb1/cmd

# lock the screen
/home/aiden/.scripts/i3lock-fancy-rapid 20 20 -n

echo idle > /dev/input/ckb1/cmd

# sleep 1 adds a small delay to prevent possible race conditions with suspend
sleep 1
