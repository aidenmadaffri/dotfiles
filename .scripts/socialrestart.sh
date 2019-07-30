#!/bin/bash
killall Discord
sleep 0.5
killall Discord
killall thunderbird
killall pulse-sms
sleep 2.5
thunderbird & disown
pulse-sms & disown
discord & disown