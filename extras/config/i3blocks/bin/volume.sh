#!/bin/bash

case $BLOCK_BUTTON in
	4)
		volume=$(pactl --format json get-sink-volume @DEFAULT_SINK@ | jq -r '[.volume[].value_percent | .[:-1] | tonumber] | max')
		[[ $volume -ge 100 ]] ||
		pactl set-sink-volume @DEFAULT_SINK@ +5%
		;;
	5)
		pactl set-sink-volume @DEFAULT_SINK@ -5%
		;;
	3)
		pactl set-sink-mute @DEFAULT_SINK@ toggle
		#pactl set-source-mute @DEFAULT_SOURCE@ toggle
		;;
esac

volume=$(pactl --format json get-sink-volume @DEFAULT_SINK@ | jq -r '[.volume[].value_percent | .[:-1] | tonumber] | max')

mute=$(pactl --format json get-sink-mute @DEFAULT_SINK@ | jq -r .mute)

if $mute ; then
	color='#808080'
elif [[ $volume -lt 50 ]] ; then
	color='#ffff00'
elif [[ $volume -le 100 ]] ; then
	color='#ffffff'
elif [[ $volume -gt 100 ]] ; then
	color='#00ff00'
else
	color='#ffffff'
fi

# pango version
# echo "<span foreground=\"$color\">$volume%</span>"

volume="${volume}%"
echo $volume
echo $volume
echo $color
