#!/bin/zsh
# set -x

# [[ $YT_AUTO_MASTER == true  ]] && IsMaster=true || IsMaster=false

# Assume any instance is master unless told otherwise, and then say otherwise.
IsMaster=true
[[ $YT_AUTO_MASTER == false ]] && IsMaster=false
export YT_AUTO_MASTER=false

self="$0"

ytmpv() {
	if $IsMaster ; then
		# Hack I use for testing code in the shell.
		AT=($@)
		# This is a very specific hack to get the quoting *just right*,
		# without passing a term which is technically quoted by ${(q)name},
		# but is still technically bare in the relevant scope.
		# autoargs.zsh "$self $(eval echo ${(q)${(j: :)${(q)AT}}})"
		# This works fine, but I'm testing the line after it.
		$TERMINAL -e "$self $(eval echo ${(q)${(j: :)${(q)AT}}})"
		# $TERMINAL -e "zsh -ic \"$self \$(eval echo ${(q)${(j: :)${(q)AT}}}) &\!\""
	else
		{
		mpv \
			--ytdl \
			--ytdl-format="bestvideo[height<=1080]+bestaudio" \
			"$@"
		}
	fi
}

case "${${${0:t}#yt_to_}%.zsh}" in
	xsel)
		ytmpv "$@" "$(xsel -bo)"
		;;
	mpv)
		ytmpv "$@"
		;;
	xloop)
		while true
		do
			cmd='ytmpv "$@" "$(xsel -bo)"'
			printf '%s\n[Y/n] ' "$cmd"
			read -q yn
			print
			[[ $yn == y ]] && eval "$cmd"
		done
		;;
esac
