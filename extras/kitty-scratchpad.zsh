#!/bin/zsh
# vim: syn=hash cms=#\ %s tw=80


# tmux music
MUSIC=music
if ! tmux has-session -t $MUSIC >/dev/null 2>/dev/null ; then
	tmux new-session -t $MUSIC -s $MUSIC -d
	tmux send-keys -t $MUSIC:0.0 "msh mpc" enter C-l enter
	tmux split-window -hd -t $MUSIC:0.0
	tmux send-keys -t $MUSIC:0.1 "mpc-display" enter
fi



# tmux youtube
YOUTUBE=youtube
if ! tmux has-session -t $YOUTUBE >/dev/null 2>/dev/null ; then
	mkdir -p /tmp/ytdl
	tmux new-session -t $YOUTUBE -s $YOUTUBE -d
fi



# kitty window
SCRATCHPAD=scratchpad
sleep 0.5
kitty \
	--title $SCRATCHPAD \
	--session sessions/scratchpad.conf \
	-o background_opacity=1 \
	--start-as minimized \
	;

