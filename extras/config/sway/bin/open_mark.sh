#!/bin/bash

# this script is supported by logic in my sway config.
# it is not expected to be functional without that logic.

mark=$1

# jq: is mark in list
has_mark="map(.==\"$mark\" or .==\"_$mark\") | any"

# if mark exists
if swaymsg -t get_marks | jq -e "$has_mark" >/dev/null ; then
	# if mark is focused
	if swaymsg -t get_tree | jq -e ".. |
		select(.focused?).marks | $has_mark" >/dev/null ; then
		swaymsg 'move scratchpad'
	else
		swaymsg "[con_mark=\"^_?$mark$\"] move scratchpad"
		swaymsg "[con_mark=\"^_?$mark$\"] focus"
		swaymsg "[con_mark=\"^_?$mark$\"] resize set width 50 ppt height 80 ppt"
		swaymsg "[con_mark=\"^_?$mark$\"] move position center"
	fi
else
	# mark doesnt exist, create it
	case $mark in
		volume)
			swaymsg 'exec $term -T pulsemixer pulsemixer'
			;;
		bluetooth)
			swaymsg exec 'blueman-manager'
			;;
		music)
			swaymsg 'exec $term -T "tmux: music" tmx music'
			;;
		mynoise)
			swaymsg exec 'firefox --new-window https://mynoise.net/noiseMachines.php'
			sleep 0.1
			;;
	esac
fi
