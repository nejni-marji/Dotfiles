#!/bin/zsh
set -x
espeak 'hacky toggle'
#
# flipsplit.zsh
#

SOCKET=$(ls -t /run/user/$(id -u)/sway-ipc.* | head -n1)

# {{{ help text
show_help() {
>&2 <<-EOM
Usage: $0 STYLE [WORKSPACE]
	STYLE can be either 'split' or 'merge'.
	If WORKSPACE is not specified, default to the currently focused workspace.
	    -h, --help  show this message and exit
EOM
exit 0
}

if [[ $1 =~ '^(-?h|(--)?help)$' ]] ; then
	show_help
fi
# }}}

# {{{ validate arguments
oldStyle="$1"
wsNum="$2"

{
	! [[ $oldStyle =~ '^(split|merge)$' ]] \
	||
	! [[ $wsNum =~ '^[[:digit:]]*$' ]]
} && show_help # this runs exit()

[[ -z $wsNum ]] && wsNum="$(i3-msg -s $SOCKET -t get_workspaces | jq '.[] | select(.focused) | .num')"
# }}}



# functions for fs_enable()

# {{{ helper json data
STYLES='{
	"splith": "split",
	"splitv": "split",
	"stacked": "merge",
	"tabbed": "merge"
}'
FLIPS='{
	"splith": "tabbed",
	"splitv": "stacked",
	"tabbed": "splith",
	"stacked": "splitv"
}'
# }}}

# {{{ fs_fix_ws_node(wsNum, oldStyle)
	# Returns as a string a command which fixes a bad workspace object.
	# If the workspace has more than 1 child, then we must individually set its
	# layout. The workspace object is weird when it comes to its layout, and
	# this is required to make it usable for the rest of the program.
	# Uses pseudo-constant $STYLES and $FLIPS.
# }}}
fs_fix_ws_node() { # {{{
	i3-msg -s $SOCKET -t get_tree \
		| jq \
			--argjson STYLES "$STYLES" \
			--argjson FLIPS "$FLIPS" \
			--argjson wsNum "$1" \
			--arg oldStyle "$2" \
		'
		..
		| select(.num?==$wsNum)
		| if
			(.nodes | length)>=2
			and
			($STYLES[.layout]==$oldStyle)
			and
			(any(
				# the gen and cond should be changed later.
				# dupe_fs_excl
				.nodes[].marks?[]? ;
				startswith("fs_excl")
				or
				startswith("FS_EXCL")
			) | not)
		then
			"[con_id=\(.id)] layout \(.layout)"
			# "[con_id=\(.id)] layout \($FLIPS[.layout])"
			# 	+ " ; "
			# 	+ "[con_id=\(.id)] layout \(.layout)"
		else
			null
		end
		'
}
# }}}

# {{{ fs_get_nodes_to_flip(wsNum, oldStyle)
	# Returns node objects that should be flipped, not in an array.
	# This ignores the workspace object itself, which is checked separately.
	# Uses pseudo-constant $STYLES.
# }}}
fs_get_nodes_to_flip() { # {{{
	i3-msg -s $SOCKET -t get_tree \
		| jq \
			--argjson STYLES "$STYLES" \
			--argjson wsNum "$1" \
			--arg oldStyle "$2" \
		'
		..
		| select(.num?==$wsNum)
		# This is the only line I had to change in order to get this to work
		# with Sway (aside from changing the default socket).
		# | .nodes[]
		| ..
		| select(
			has("id")?
			and
			(.nodes | length)>=2
			and
			($STYLES[.layout]==$oldStyle)
			and
			(any(
				# the gen and cond should be changed later.
				# dupe_fs_excl
				.nodes[].marks?[]? ;
				startswith("fs_excl")
				or
				startswith("FS_EXCL")
			) | not)
		)
		'
}
# }}}

# {{{ fs_flip_nodes()
	# Input is a sequence of object records, not an array.
	# Input is given by STDIN.
	# Returns string along the lines of:
	# 	"[con_id=94322622271600] layout tabbed, mark --add --toggle fs_used_ID"
	# Uses pseudo-constant $FLIPS
	# (This should be chained directly after fs_get_nodes_to_flip.)
	# We need two statements. One for the parent, to set mark, and one for the
	# child, to set layout.
# }}}
fs_flip_nodes() { # {{{
	jq \
		--argjson FLIPS "$FLIPS" \
	'
	"[con_id=\(.nodes[0].id)] layout \($FLIPS[.layout])"
		+ " ; "
		+ "[con_id=\(.id)] mark --add \"fs_used_\(.id)\""
	'
}
# }}}

# {{{ helpers for enable
fs_cmd_fix() {
	fs_fix_ws_node \
	"$wsNum" "$oldStyle" \
	| jq -re
}

fs_cmd_flip() {
	fs_get_nodes_to_flip \
	"$wsNum" "$oldStyle" \
	| fs_flip_nodes \
	| jq -sre 'join(" ; ")'
}
# }}}

fs_enable() { # {{{
	# fs_fix_ws_node "$wsNum" "$oldStyle"
	# fs_get_nodes_to_flip "$wsNum" "$oldStyle" | fs_flip_nodes

	# # If we want to change the workspace node, we have to force it to have only one
	# # child node before doing anything else. This is because the workspace node
	# # refuses to have a merge style under normal conditions.
	# if cmd_fix_ws_node="$(fs_cmd_fix)" ; then
	# 	# notify-send -a flipsplit 'fixing ws node'
	# 	print "${(q)cmd_fix_ws_node}"
	# 	i3-msg -s $SOCKET "$cmd_fix_ws_node"
	# 	# sleep 0.25
	# fi

	if cmd_flip_nodes="$(fs_cmd_flip)" ; then
		# notify-send -a flipsplit 'flipping nodes'
		print "${(q)cmd_flip_nodes}"
		i3-msg -s $SOCKET "$cmd_flip_nodes"
	fi
} # }}}



# functions for fs_enable()

# {{{ fs_get_nodes_to_unflip(wsNum, oldStyle)
	# Returns node objects that should be unflipped, not in an array.
	# Uses pseudo-constant $STYLES.
# }}}
fs_get_nodes_to_unflip() { # {{{
	i3-msg -s $SOCKET -t get_tree \
		| jq \
			--argjson STYLES "$STYLES" \
			--argjson wsNum "$1" \
			--arg oldStyle "$2" \
		'
		..
		| select(.num?==$wsNum)
		| .nodes[]
		| ..
		| select(
			has("id")?
			and
			(any(
				.marks[]
				;
				startswith("fs_used")
			))
		)
		'
}
# }}}

# {{{ fs_flip_nodes()
# }}}
fs_unflip_nodes() { # {{{
	jq \
		--argjson FLIPS "$FLIPS" \
	'
	"[con_id=\(.nodes[0].id)] layout \($FLIPS[.layout])"
		+ " ; "
		+ "[con_id=\(.id)] unmark \"fs_used_\(.id)\""
	'
}
# }}}

# {{{ helpers for disable
fs_cmd_unflip() {
	fs_get_nodes_to_unflip \
	"$wsNum" "$oldStyle" \
	| fs_unflip_nodes \
	| jq -sre 'join(" ; ")'
}
# }}}

fs_disable() { # {{{
	# fs_get_nodes_to_unflip "$wsNum" "$oldStyle" | fs_unflip_nodes

	if cmd_unflip_nodes="$(fs_cmd_unflip)" ; then
		# notify-send -a flipsplit 'unflipping nodes'
		print "${(q)cmd_unflip_nodes}"
		i3-msg -s $SOCKET "$cmd_unflip_nodes"
	fi
}
# }}}

# {{{ fs_check_presence()
# Return table:
# 	true	fs_used marks are present, use fs_disable
# 	false	no such marks are present, use fs_enable
# }}}
fs_check_presence() { # {{{
i3-msg -s $SOCKET -t get_tree \
	| jq \
		-e \
		--argjson wsNum "$wsNum" \
		--arg oldStyle "$oldStyle" \
	'
	..
	| select(.num?==$wsNum)
	| any(
			.. | .marks?[]?
			;
			startswith("fs_used_")
	)
	# | if . then "fs marks present" else "no marks present" end
	# | if . then "disable" else "enable" end
	'
}
# }}}



# Run final code?

if fs_check_presence ; then
	# fs_used is present
	espeak disable
	fs_disable
else
	# fs_used is not present
	espeak enable
	fs_enable
fi
