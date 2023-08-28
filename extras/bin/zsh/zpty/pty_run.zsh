#!/bin/zsh

[[ $1 =~ '^(-?h|(--)?help|)$' ]] && {
	<<-EOM_help
	Usage: ptyc [ ARG ... ]
	  or:  ptyr [ ARG ... ]
	       [c]ommand or [r]un mode: run a command under zpty,
	       using a wrapper for the 'pty' function provided by ptys.

	       Arguments are parsed similar to 'eval'.
	EOM_help
	return 1
}

DIRNAME=${0:A:h} # [A]bsolute, h is dirpath
source "$DIRNAME/pty_source.zsh"

pty $@
