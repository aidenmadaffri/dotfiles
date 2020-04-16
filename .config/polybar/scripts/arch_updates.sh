#!/usr/bin/env bash

path=${HOME}/.config/polybar/scripts/
#trap 'exit' SIGINT

function main_loop {
        while true; do
        echo '' > ~/.config/polybar/scripts/status
        check_for_updates
        sleep 600
        done
}

function status {
        echo $$ > ${path}polybar_updates.pid
        while true; do
        cat ~/.config/polybar/scripts/status
        sleep 1
        done
}

function check_for_updates {
   checkupdates | nl -w2 -s '. ' >| ${path}repo.pkgs
   yay -Qu --aur | nl -w2 -s '. '  >| ${path}aur.pkgs
   updates=$(cat ${path}*.pkgs | wc -l)

   echo "0" >| ${path}status
   [ $updates -gt 0 ] && echo "%{F#e60053}$updates" >| ${path}status

   >| ${path}packages
   [ -s ${path}repo.pkgs ] && cat ${path}repo.pkgs >> ${path}packages
   [ -s ${path}repo.pkgs ] && [ -s ${path}aur.pkgs ] && printf "\n" >> ${path}packages
   [ -s ${path}aur.pkgs ] && sed '1iAUR Updates' ${path}aur.pkgs >> ${path}packages
}

function notify {
if [[ $(cat ~/.config/polybar/scripts/status) -eq 0 ]]
then
        notify-send 0
else
        notify-send "$(cat ~/.config/polybar/scripts/packages)"
fi   
}

function upgrade {
termite -e yay --noconfirm -Syu
echo "0" > ~/.config/polybar/scripts/status
}


[[ $# -eq 0 ]] && main_loop
[[ $1 == "-s" ]] && status
[[ $1 == "-c" ]] && echo '' > ~/.config/polybar/scripts/status && check_for_updates
[[ $1 == "-n" ]] && notify
[[ $1 == "-u" ]] && upgrade
