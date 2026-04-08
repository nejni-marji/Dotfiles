#!/bin/bash

case $BLOCK_BUTTON in
	3)
		b1=$(brightnessctl | grep -Po '\d+(?=%)')
		b2=$(( ($b1+3)/5*5 ))
		brightnessctl set $b2% >/dev/null
		;;
	4)
		brightnessctl set -- +5% >/dev/null
		;;
	5)
		brightnessctl set -- -5% >/dev/null
		;;
esac

brightness=$(brightnessctl | grep -Po '\d+%')

echo $brightness
