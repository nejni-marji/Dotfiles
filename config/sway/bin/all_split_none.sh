#!/bin/bash
for i in $(swaymsg -t get_tree | jq '.. | select(.type?=="con" and (.nodes | length==1)).nodes[].id') ; do
	swaymsg "[con_id=$i] split none"
done
