#!/bin/bash

num=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true) | .num')

case $1 in
	p|prev)
		[[ $num -le 0 ]] && exit
		target="$((num-1))"
		;;
	n|next)
		target="$((num+1))"
		;;
	P|prev_main)
		[[ $num -le 0 ]] && exit
		target="$(( ($num-1) - ( ($num-1) % 10) + 00 ))"
		;;
	N|next_main)
		target="$(( ($num-0) - ( ($num-0) % 10) + 10 ))"
		;;
esac

[[ $target -lt 0 ]] && exit

echo "\"$target\""

# Everything beyond this point is based on my configuration. Notably, my
# workspace variables are $w0, $w1, $w2 .. $w9
# I grep my config for that, so if yours are different, then you may want to
# change the regex.

if [[ $target =~ ^[0-9]0$|^0$ ]]; then
	echo "e: \"$target\""
	target=$(swaymsg -t get_config | jq -r .config | grep -Po "(?<=set \\\$ws$(($target/10)) )\d0(:.*)?")
fi

echo "\"$target\""

case $2 in
	take)
		swaymsg -- "move container to workspace number $target ; workspace number $target"
		;;
	*)
		swaymsg -- "workspace number $target"
		;;
esac
