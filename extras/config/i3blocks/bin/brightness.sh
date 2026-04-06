#!/bin/bash

case $BLOCK_BUTTON in
	4)
		brightnessctl set -- +5% >/dev/null
		;;
	5)
		brightnessctl set -- -5% >/dev/null
		;;
esac

brightness=$(brightnessctl | grep -Po '\d+%')

echo $brightness
