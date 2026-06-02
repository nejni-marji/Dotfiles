#!/bin/zsh

[[ $1 =~ '^(-?h|(--)?help|)$' ]] && {
	<<-EOM_help
	Usage: ptyw [ ARG ... ]
	       [w]atch mode: run a command under zpty,
	       using a wrapper for the 'pty' function provided by ptys,
	       but also pass it to 'zsh -ic' first, for full interactivity,
	       and then pass that through 'watch --color'.
	
	       Arguments are parsed similar to 'eval'.
	EOM_help
	return 1
}

DIRNAME=${0:A:h} # [A]bsolute, h is dirpath
ORIGIN="$0" HELP="$1" \
source "$DIRNAME/pty_source.zsh"

echo "${(q-)@}"
watch --color "zpti ${(q-)@}"
