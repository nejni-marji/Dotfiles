#!/bin/zsh

# store to $dir or die
[[ $1 =~ 'up|down|left|right' ]] && dir=$1 || exit 10

id=$(swaymsg -t get_tree | jq -r --arg dir $dir '

. as $tree |

{
	"left": "splith",
	"right": "splith",
	"up": "splitv",
	"down": "splitv"
}[$dir] as $good_layout |

{
	"left": 0,
	"right": 1,
	"up": 0,
	"down": 1,
}[$dir] as $dir_sign |

def get_good_parent:
	if .layout==$good_layout then . else
		.id as $prev_id |
		$tree | .. |
		select(.nodes? | length!=0) |
		select(.nodes | map(.id) | contains([$prev_id])) |
		get_good_parent
	end
;

# get correct parent of focused with recursive function
$tree | .. | select(.focused?) | get_good_parent |

# parent aka parent, source aka highest
. as $parent |
.id as $parent_id |
.focus[0] as $child_id |

#"child \($child_id) parent \($parent_id)"

# next, we need to get the target neighbor of $child_id

$parent.nodes |
	map(.id) as $nodes | length as $length |
	$nodes | index($child_id) |
	. as $index |
	# pass empty if there is no next neighbor
	if $index == $dir_sign*($length-1) then empty else
		$nodes[$index + [-1, 1][$dir_sign]]
	end |
	. as $neighbor_id |

def get_lowest_child:
	if .focus == [] then . else
		.focus[0] as $foc |
		.nodes | map(select(.id==$foc))[0] | get_lowest_child
	end
;

$parent | .nodes |
	map(select(.id?==$neighbor_id))[0] |
	get_lowest_child |
	# pass empty if the target is not visible
	if .visible then .id else empty end
')

swaymsg "[con_id=$id] focus"
