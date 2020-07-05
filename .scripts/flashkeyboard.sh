#!/bin/bash
cd $HOME/Downloads
notify-send -t 3000 "Press the reset button to continue..."
wally-cli $(/bin/ls -t ergodox* | head -1)
sleep 5
xset r rate 345 25
notify-send -t 3000 "Keyboard has been flashed."