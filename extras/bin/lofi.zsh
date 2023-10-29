#!/bin/zsh

case $1 in
	study|relax|DEFAULT)
		query="lofi girl lofi hip hop radio beats to study relax to"
		;;
	sleep|chill)
		query="lofi girl lofi hip hop radio beats to sleep chill to"
		;;
	synthwave|synth|game|gaming)
		query="lofi girl synthwave radio beats to chill game to"
		;;
	*)
		query="lofi girl lofi hip hop radio beats to study relax to"
		;;
esac

opts=(
	--ytdl
	--script-opts=ytdl_path=yt-dlp
	--ytdl-format='bv[height<=300]+ba/b'
	--no-pause
	--no-video
	--load-unsafe-playlists=no
	--keep-open=yes
	--loop-playlist=no
	--volume=70
	--start=0
)

mpv $opts "ytdl://ytsearch: $query "
