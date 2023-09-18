#!/bin/zsh
# vim: syn=hash cms=#\ %s tw=80

cd

# tmux music
MUSIC=music
if ! tmux has-session -t $MUSIC >/dev/null 2>/dev/null ; then
	tmux new-session -c $HOME -t $MUSIC -s $MUSIC -d
	tmux send-keys -t $MUSIC:0.0 "msh mpc" enter C-l enter
	tmux split-window -hd -t $MUSIC:0.0
	tmux send-keys -t $MUSIC:0.1 "mpc-display" enter
fi

# tmux youtube
YOUTUBE=youtube
YT_DIR=/tmp/ytdl
if ! tmux has-session -t $YOUTUBE >/dev/null 2>/dev/null ; then
	mkdir -p $YT_DIR
	tmux new-session -c $YT_DIR -t $YOUTUBE -s $YOUTUBE -d
fi

# kitty window
SCRATCHPAD=scratchpad
# sleep 0.5
kitty \
	--title $SCRATCHPAD \
	--session sessions/scratchpad.conf \
	-o background_opacity=1 \
	--start-as minimized \
	;
