#!/bin/bash
#
# this script is supported by logic in my sway config.
# it is not expected to be functional without that logic.
# an example is provided below:
#
#    for_window [...] mark _volume
#    for_window [...] mark _bluetooth
#
#    set $toggle_mark for_window [con_mark="^_?(app1|app2)$"]
#    $toggle_mark floating enable
#    $toggle_mark border $border
#    $toggle_mark move scratchpad
#    $toggle_mark scratchpad show
#    $toggle_mark resize set width 50 ppt height 80 ppt
#    $toggle_mark move position center
#
#    bindsym $mod+$alt+v exec ~/.config/sway/bin/toggle_mark.sh volume '$term -T pulsemixer pulsemixer'
#    bindsym $mod+$alt+b exec ~/.config/sway/bin/toggle_mark.sh bluetooth 'blueman-manager'
#

mark=$1
cmd=$2

# jq: is mark in list
has_mark="map(.==\"$mark\" or .==\"_$mark\") | any"

# if mark exists
if swaymsg -t get_marks | jq -e "$has_mark" >/dev/null ; then
	# if mark is focused
	if swaymsg -t get_tree | jq -e ".. |
		select(.focused?).marks | $has_mark" >/dev/null ; then
		swaymsg 'move scratchpad'
	else
		swaymsg "[con_mark=\"^_?$mark$\"] move scratchpad"
		swaymsg "[con_mark=\"^_?$mark$\"] focus"
		swaymsg "[con_mark=\"^_?$mark$\"] resize set width 50 ppt height 80 ppt"
		swaymsg "[con_mark=\"^_?$mark$\"] move position center"
	fi
else
	# mark doesnt exist, create it
	swaymsg exec "$cmd"
fi
