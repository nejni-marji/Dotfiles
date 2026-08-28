#!/bin/bash

# save the most recent notification id
latest="$(for i in list history ; do makoctl $i -j ; done |
	jq -s '[.[][].id] | sort[-1]')"

echo $latest > ~/.makodnd

# toggle dnd and update the status bar
makoctl mode -t do-not-disturb
pkill -SIGRTMIN+3 i3blocks
