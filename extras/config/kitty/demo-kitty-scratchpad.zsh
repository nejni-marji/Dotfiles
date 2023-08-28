#!/bin/zsh

if ! tmux has-session -t demo_music 2>/dev/null ; then
	tmux new-session -s demo_music -d
	tmux split-window -t demo_music:0 -h -d
	tmux send-keys -t demo_music:0.0 "msh mpc" enter C-l enter
	tmux send-keys -t demo_music:0.1 "mpc-display" enter
	sleep 0.5
fi

if ! tmux has-session -t demo_youtube 2>/dev/null ; then
	mkdir /tmp/ytdl
	tmux new-session -s demo_youtube -d -c /tmp/ytdl
fi

kitty --title demo_scratchpad --session ~/demo_scratchpad.conf
