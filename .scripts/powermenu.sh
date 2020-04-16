#!/bin/bash

## Created By Aditya Shakya

MENU="$(rofi -sep "|" -dmenu -i -p 'System' -location 3 -yoffset 60 -xoffset -28 -width 15 -hide-scrollbar -line-padding 4 -padding 20 -lines 4 -font "NotoSans Nerd Font Regular 12" <<< " Lock| Logout| Reboot| Shutdown")"
            case "$MENU" in
                *Lock) $HOME/.scripts/screenoff.sh ;;
                *Logout) bspc quit;;
                *Reboot) shutdown -r now ;;
                *Shutdown) shutdown
esac
