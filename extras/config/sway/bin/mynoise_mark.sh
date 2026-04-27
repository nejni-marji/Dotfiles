#!/bin/bash

# [title="myNoise ®|Natural Ambience Sound Generator"]

if swaymsg -t get_marks | jq -e 'contains(["mynoise"])' ; then
	if swaymsg -t get_tree | jq -e '.. | select(.focused?).marks | contains(["mynoise"])' ; then
		swaymsg move scratchpad
	else
		swaymsg '[con_mark="^mynoise$"] focus'
	fi
else
	swaymsg exec 'firefox --new-window https://mynoise.net/noiseMachines.php'
	sleep 0.1
fi
