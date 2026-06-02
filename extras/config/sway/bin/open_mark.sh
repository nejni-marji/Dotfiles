#!/bin/bash

case $1 in
	volume|vol)
		mark=vol
		;;
	bluetooth|bt)
		mark=bt
		;;
	music)
		mark=music
		;;
	mynoise)
		mark=mynoise
		;;
	*)
		exit
		;;
esac


if swaymsg -t get_marks | jq -e 'contains(["'"${mark}"'"])' >/dev/null ; then
	if swaymsg -t get_tree | jq -e '.. |
		select(.focused?).marks | contains(["'"${mark}"'"])' >/dev/null ; then
		swaymsg 'move scratchpad'
	else
		swaymsg '[con_mark="^'"${mark}"'$"] move scratchpad'
		swaymsg '[con_mark="^'"${mark}"'$"] focus'
		swaymsg '[con_mark="^'"${mark}"'$"] resize set width 50 ppt height 80 ppt'
		swaymsg '[con_mark="^'"${mark}"'$"] move position center'
	fi
else
	case $mark in
		vol)
			swaymsg 'exec $term -T pulsemixer pulsemixer'
			;;
		bt)
			swaymsg exec 'blueman-manager'
			;;
		music)
			swaymsg 'exec $term -T "tmux: music" tmx music'
			;;
		mynoise)
			swaymsg exec 'firefox --new-window https://mynoise.net/noiseMachines.php'
			sleep 0.1
			;;
		*)
			;;
	esac
fi
