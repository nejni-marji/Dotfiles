#!/bin/bash

while
	swaymsg -t get_tree |
		$(dirname $0)/representation.jq
do
	swaymsg -t subscribe \
		'["window", "workspace", "output", "binding"]' \
		>/dev/null 2>&1
	# sleep for 1/2 a 60Hz refresh, should be enough. we *are* fighting a race condition here
	sleep 0.008
done
