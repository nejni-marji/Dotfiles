#!/usr/bin/env zsh
# vim: fdm=indent
#
# ytsearch.zsh
#
# this script is supposed to add a command kind of like microshell.zsh, but the
# goal is to preload an mpv command into the zle buffer so that i can watch
# youtube videos from the command line more easily. it's kind of dumb bullshit
# but thats what i love to do <3



# Sun, Jan 29, 19:07
# Let's redo this a THIRD time, and hopefully this time, make it a bit more
# flexible?
#
# Sample command:
#
# mpv --ytdl --script-opts=ytdl_path=$(which yt-dlp) --ytdl-format='bestvideo[height<=500]+bestaudio[ext!=webm]/best' --no-pause --no-fullscreen --load-unsafe-playlists=no --keep-open=always--loop-playlist=no --volume=100 --start=0 'https://www.youtube.com/watch?v=Byqxloto4vI'
#
# Differences between video and audio:
#
# ytdl-format .... reduced quality
# fullscreen ..... unused
# video .......... disabled
# keep-open ...... always -> yes
# volume ......... 100 -> 70



YT_VIDEO=(
	"mpv --ytdl --script-opts=ytdl_path=yt-dlp --ytdl-format='bestvideo[height<=800]+bestaudio[ext!=webm]/best' --no-pause --no-fullscreen --load-unsafe-playlists=no --keep-open=always --loop-playlist=no --volume=100 --start=0 '"
	"' && exit"
)
YT_AUDIO=(
	"mpv --ytdl --script-opts=ytdl_path=yt-dlp --ytdl-format='bestvideo[height<=300]+bestaudio[ext!=webm]/best' --no-pause --no-video --load-unsafe-playlists=no --keep-open=yes --loop-playlist=no --volume=70 --start=0 '"
	"' && exit"
)
YT_SEARCH=(
	"ytdl://ytsearch: "
	" "
)

ytvideo() {
	zle-line-init() {
		BUFFER=''
		BUFFER+=${YT_VIDEO[1]}
		CURSOR=${#BUFFER}
		BUFFER+=${YT_VIDEO[2]}
		CURSOR+=1
		zle vi-cmd-mode
		zle split-undo
		zle vi-insert
		zle -D zle-line-init
	}
	zle -N zle-line-init
}
ytaudio() {
	zle-line-init() {
		BUFFER=''
		BUFFER+=${YT_AUDIO[1]}
		CURSOR=${#BUFFER}
		BUFFER+=${YT_AUDIO[2]}
		CURSOR+=1
		zle vi-cmd-mode
		zle split-undo
		zle vi-insert
		zle -D zle-line-init
	}
	zle -N zle-line-init
}
ytsearchvideo() {
	zle-line-init() {
		BUFFER=''
		BUFFER+=${YT_VIDEO[1]}
		BUFFER+=${YT_SEARCH[1]}
		CURSOR=${#BUFFER}
		BUFFER+=${YT_SEARCH[2]}
		BUFFER+=${YT_VIDEO[2]}
		CURSOR+=1
		zle vi-cmd-mode
		zle split-undo
		zle vi-insert
		zle -D zle-line-init
	}
	zle -N zle-line-init
}
ytsearchaudio() {
	zle-line-init() {
		BUFFER=''
		BUFFER+=${YT_AUDIO[1]}
		BUFFER+=${YT_SEARCH[1]}
		CURSOR=${#BUFFER}
		BUFFER+=${YT_SEARCH[2]}
		BUFFER+=${YT_AUDIO[2]}
		CURSOR+=1
		zle vi-cmd-mode
		zle split-undo
		zle vi-insert
		zle -D zle-line-init
	}
	zle -N zle-line-init
}

alias ytv=ytvideo
alias yta=ytaudio
alias ytsa=ytsearchaudio
alias ytsv=ytsearchvideo
