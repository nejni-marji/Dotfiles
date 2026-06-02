#!/bin/bash

# TODO:
# - toggle cursor
# - panorama mode

image_path=~/Pictures/Screenshots/Screenshot_$(date +"%F_%H%M%S")_$HOSTNAME.png
echo $image_path
output="$(swaymsg -t get_outputs |
	jq -r '.[] | select(.focused).name'
)"

# slurp isn't necessary because satty can crop after the fact
# show cursor in screenshots
grim -o $output - |
	satty \
	--filename - \
	--fullscreen \
	--output-filename $image_path \
	--copy-command=wl-copy \
	--actions-on-enter save-to-clipboard,exit \
	--actions-on-escape exit \
	--early-exit \
	;

[[ -f $image_path ]] &&
	wl-copy < $image_path
