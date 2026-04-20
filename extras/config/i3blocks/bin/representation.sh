#!/bin/zsh

while
	swaymsg -t get_tree |
		$(dirname $0)/representation.jq
do
	swaymsg -t subscribe \
		'["window", "workspace", "output", "binding"]' \
		>/dev/null 2>&1
	# sleep for quarter a 60Hz refresh, should be enough
	sleep 0.004
done
