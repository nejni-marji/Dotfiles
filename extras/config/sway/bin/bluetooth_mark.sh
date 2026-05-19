#!/bin/bash

if swaymsg -t get_marks | jq -e 'contains(["bt"])' ; then
	if swaymsg -t get_tree | jq -e '.. |
		select(.focused?).marks | contains(["bt"])' ; then
		swaymsg 'move scratchpad'
	else
		swaymsg '[con_mark="^bt$"] move scratchpad'
		swaymsg '[con_mark="^bt$"] focus'
		swaymsg '[con_mark="^bt$"] resize set width 50 ppt height 80 ppt'
		swaymsg '[con_mark="^bt$"] move position center'

	fi
else
	swaymsg exec 'blueman-manager'
fi
