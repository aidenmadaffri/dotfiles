#!/bin/bash
function volUp {
	if playerctl -p spotify status | grep Playing > /dev/null
	then
		app_name="Spotify"
		
		current_sink_num=''
		sink_num_check=''
		app_name_check=''
		
		pactl list sink-inputs |while read line; do \
		    sink_num_check=$(echo "$line" |sed -rn 's/^Sink Input #(.*)/\1/p')
		    if [ "$sink_num_check" != "" ]; then
		        current_sink_num="$sink_num_check"
		    else
		        app_name_check=$(echo "$line" \
		            |sed -rn 's/application.name = "([^"]*)"/\1/p')
		        if [ "$app_name_check" = "$app_name" ]; then
		            echo "$current_sink_num" "$app_name_check"
		
		            pactl set-sink-input-volume "$current_sink_num" +5%
		        fi
		    fi
		done
	else
		$HOME/.scripts/pavolume.sh --up
	fi	
}

function volDown {
	if playerctl -p spotify status | grep Playing > /dev/null
	then
	    app_name="Spotify"
	    		
	    		current_sink_num=''
	    		sink_num_check=''
	    		app_name_check=''
	    		
	    		pactl list sink-inputs |while read line; do \
	    		    sink_num_check=$(echo "$line" |sed -rn 's/^Sink Input #(.*)/\1/p')
	    		    if [ "$sink_num_check" != "" ]; then
	    		        current_sink_num="$sink_num_check"
	    		    else
	    		        app_name_check=$(echo "$line" \
	    		            |sed -rn 's/application.name = "([^"]*)"/\1/p')
	    		        if [ "$app_name_check" = "$app_name" ]; then
	    		            echo "$current_sink_num" "$app_name_check"
	    		
	    		            pactl set-sink-input-volume "$current_sink_num" -5%
	    		        fi
	    		    fi
	    		done
	else
		$HOME/.scripts/pavolume.sh --down
	fi	
}

case "$1" in
	--up)
		volUp
		;;
	--down)
		volDown
		;;
esac