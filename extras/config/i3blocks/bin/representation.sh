#!/bin/zsh

while
	# get representation and index
	rep="$(swaymsg -t get_workspaces |
		jq -cr '..
		| select(.focused? and .type=="workspace").representation
		| if .==null then
		"•" else
			gsub("(?<=\\[| )[\\w_-]+(?!\\[) ?"; "•")
			| gsub("•(?<a>[HVTS])"; "• \(.a)")
			#| gsub("(?<a>•{6,})"; "\(.a | length)")
			#| gsub("(?<b>\\d)(?<a>[HVTS])"; "\(.b) \(.a)")
		end'
	)"

	# get index of focus
	local -i index="$(swaymsg -t get_tree |
		jq '..
		| select(.type?=="workspace")
		| select(.. | .focused?)
		| [.. | select(.id?) | .focused]
		| index(true)+1'
	)"

	# get subindex of focus
	#local -i subindex="$(swaymsg -t get_tree |
	#	jq '..
	#	| select(.nodes?)
	#	| select(.nodes[].focused)
	#	| [.nodes[].focused]
	#	| index(true)+1'
	#)"

	# "crawl the tape" to determine the real offset
	local -i tape=0
	local -i offset=0
	for i in {1..$#rep} ; do
		char=$rep[$i]

		# if its HVTSm then increment
		if [[ 'HVTS•' == *$char* ]] ; then
			offset+=1

		# if its a number, add that number
		elif [[ '123456789' == *$char* ]] ; then
			offset+=$char

		fi

		if [[ $index -le $offset ]] ; then
			break
		fi

		# increment tape after that conditional
		tape+=1
	done

	# color output if necessary
	span1=''
	span2=''
	frac=''

	if [[ $tape -lt $#rep ]] ; then
		span1='<span foreground="#ff8cda">'
		span2='</span>'

		#if [[ '0123456789' == *${rep[$tape+1]}* ]] ; then
		#	frac="${subindex}/"
		#fi
	fi

	echo "${rep[1,$tape]}${span1}${frac}${rep[$tape+1]}${span2}${rep[$tape+2,-1]}"

	# return true to preserve while
	true
do swaymsg -t subscribe \
	'["window", "workspace", "output", "binding"]' \
	>/dev/null 2>&1
	# sleep for quarter a 60Hz refresh, should be enough
	sleep 0.004
done
