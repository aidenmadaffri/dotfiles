#!/bin/bash
killall Discord
killall electron-mail
sleep 2.5
killall Discord
killall thunderbird
killall pulse-sms
killall electron-mail
sleep 5
thunderbird & disown
pulse-sms & disown
discord & disown
electron-mail & disown