#!/bin/bash
if [ ! -f /tmp/focus-mode.lock ]; then
    touch /tmp/focus-mode.lock
    notify-send "Focus Mode Enabled" -t 3000
    sleep 3.1
    notify-send "DUNST_COMMAND_PAUSE"
    killall Discord
    bspc config window_gap 0
    bspc config border_width 1
    $XDG_CONFIG_HOME/polybar/launchfocused.sh &
else
    notify-send "DUNST_COMMAND_RESUME"
    bspc config window_gap 8
    bspc config border_width 2
    $XDG_CONFIG_HOME/polybar/launch.sh &
    notify-send "Focus Mode Disabled" -t 3000
    discord &
    rm /tmp/focus-mode.lock
fi

