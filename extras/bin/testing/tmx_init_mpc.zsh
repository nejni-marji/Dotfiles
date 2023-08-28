#!/bin/zsh

# make the session
# tmux new-session -t mpc -s mpc -d -x 136 -y 31
tmux new-session -t mpc -s mpc -d

# split the window
tmux split-window -t mpc:0.0 -v
tmux split-window -t mpc:0.1 -h

# resize the one pane we care about
# tmux resize-pane -t mpc:0.1 -x 68 -y 6

# set commands for each pane

tmux send-keys -t mpc:0.0 'whread.zsh mpc_playlist'
tmux send-keys -t mpc:0.1 'mpc_watch 5'
tmux send-keys -t mpc:0.2 'msh mpc'

for i in {0..2} ; do
	tmux send-keys -t mpc:0.$i C-m
done

tmux send-keys -t mpc:0.2 C-l
