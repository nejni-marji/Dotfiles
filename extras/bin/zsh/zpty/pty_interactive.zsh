#!/bin/zsh

[[ $1 =~ '^(-?h|(--)?help|)$' ]] && {
	<<-EOM_help
	Usage: ptyi [ ARG ... ]
	       [i]nteractive mode: run a command under zpty,
	       using a wrapper for the 'pty' function provided by ptys,
	       but also pass it to 'zsh -ic' first, for full interactivity.
	
	       Arguments are parsed similar to 'eval'.
	EOM_help
	return 1
}

DIRNAME=${0:A:h} # [A]bsolute, h is dirpath
ORIGIN="$0" HELP="$1" \
source "$DIRNAME/pty_source.zsh"

pty zsh -ic \"$@\"
