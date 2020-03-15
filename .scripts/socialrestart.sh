#!/bin/bash
killall Discord
killall electron-mail
sleep 2.5
killall Discord
killall thunderbird
killall electron-mail
sleep 5
thunderbird & disown
discord & disown
electron-mail & disown