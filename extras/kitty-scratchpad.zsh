# vim: syn=hash cms=#\ %s tw=80
#
# init-kitty-scratchpad.zsh
#



# tmux music
music=music-demo
if ! tmux has-session -t $music >/dev/null 2>/dev/null ; then
	tmux new-session -t $music -s $music -d
	tmux send-keys -t $music:0.0 "msh mpc" enter C-l enter
	tmux split-window -hd -t $music:0.0
	tmux send-keys -t $music:0.1 "mpc-display" enter
fi



# tmux youtube
youtube=youtube-demo
if ! tmux has-session -t $youtube >/dev/null 2>/dev/null ; then
	mkdir -p /tmp/ytdl
	tmux new-session -t $youtube -s $youtube -d
fi



# kitty window
scratchpad=scratchpad-demo
sleep 0.5
kitty \
	--title $scratchpad \
	--session sessions/scratchpad.conf \
	-o background_opacity=1 \
	--start-as minimized \
	;

