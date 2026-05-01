#!/bin/bash

if swaymsg -t get_marks | jq -e 'contains(["vol"])' ; then
	if swaymsg -t get_tree | jq -e '.. | select(.focused?).marks | contains(["vol"])' ; then
		swaymsg 'move scratchpad'
	else
		swaymsg '[con_mark="^vol$"] move scratchpad'
		swaymsg '[con_mark="^vol$"] focus'
		swaymsg '[con_mark="^vol$"] resize set width 50 ppt height 80 ppt'
		swaymsg '[con_mark="^vol$"] move position center'
	fi
else
	swaymsg 'exec $term -T pulsemixer pulsemixer'
fi
