#!/bin/bash

if swaymsg -t get_marks | jq -e 'contains(["music"])' ; then
	if swaymsg -t get_tree | jq -e '.. |
		select(.focused?).marks | contains(["music"])' ; then
		swaymsg 'move scratchpad'
	else
		swaymsg '[con_mark="^music$"] move scratchpad'
		swaymsg '[con_mark="^music$"] focus'
		swaymsg '[con_mark="^music$"] resize set width 50 ppt height 80 ppt'
		swaymsg '[con_mark="^music$"] move position center'
	fi
else
	swaymsg 'exec $term -T "tmux: music" tmx music'
fi
