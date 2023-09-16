#!/bin/bash
DELAY="$1"
[[ -z $DELAY ]] && DELAY=3

export MPC_FORMAT='[[##%track%\t][[%artist% .... ]%title%]|[%file%]]\n'
export MPC_FORMAT='[[%title%]|%file%][\nBy: %artist%][\n\[%album%\] ##%track%]\n'

while true; do

	clear
	# mpc status | fold -s -w "$(tput cols)" \
	# | perl -pe 's/^(\s(?!$))*//'
	~/bin/mpc_status

	if ! mpc | grep '^\[playing\]' >/dev/null; then
		mpc idle

	else
		sleep $DELAY

	fi
done
