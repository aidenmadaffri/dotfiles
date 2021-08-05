#!/bin/sh

# Session
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=sway
export XDG_CURRENT_DESKTOP=sway
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

# My vars
export MOZ_DISABLE_RDD_SANDBOX=1
export EDITOR=nvim
export TERMINAL=alacritty
export BROWSER=firefox

source /home/aiden/.scripts/wayland_vars.sh

systemd-cat --identifier=sway sway $@
