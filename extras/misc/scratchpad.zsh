#!/bin/zsh
# vim: nolist

SPECIAL_ARG='4f19c78e-2eff-42c1-a15a-dc7581a03ca5'
NAME=scratchpad


if [[ $1 != $SPECIAL_ARG ]] ; then
	exec cool-retro-term \
		-T scratchpad \
		-p scratchpad \
		-e ${0:A} $SPECIAL_ARG
fi

# start from home
cd
mkdir -p /tmp/ytdl

if ! tmux has-session -t $NAME ; then

	# setup session
	tmux new-session -s $NAME -d
	tmux set-env -t $NAME ASCII_ONLY true
	tmux new-window -t $NAME
	tmux kill-window -t $NAME:0

	# make windows

	tmux new-window -t $NAME \
		-n audio \
		pulsemixer

	tmux new-window -t $NAME \
		-c ~/Working/rust/mpc-display-rs \
		-n music \
		;

	tmux send-keys -t $NAME:2 'mpc-display-rs' enter

	# select window
	tmux select-window -t $NAME:2

	# kill temp window
	tmux kill-window -t $NAME:0
fi

tmux attach-session \
	-c /tmp/ytdl
	-t $NAME

tmux kill-session -t $NAME
