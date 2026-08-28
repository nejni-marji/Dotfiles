#!/bin/bash

if makoctl mode 2>/dev/null | grep do-not-disturb >/dev/null ; then
	# get the most recent notification id
	latest="$(for i in list history ; do makoctl $i -j ; done |
		jq -s '[.[][].id] | sort[-1]')"
	# get the last notification id from before dnd was enabled
	previous="$(cat ~/.makodnd)"
	# calculate number of new messages
	msg_count=$(( $latest - $previous ))

	if [[ $msg_count -eq 0 ]] ; then
		echo "🔕"
	else
		echo "🔕 $msg_count"
	fi
fi
