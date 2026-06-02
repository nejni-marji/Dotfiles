#!/bin/zsh

[[ $_ != $0 ]] && [[ $1 =~ '^(-?h|(--)?help|)$' ]] && {
	<<-EOM_help
	Usage: source ptys
	 and:  pty [ ARG ... ]
	       [s]ource mode: source this file to get the 'pty' function.
	       This function lets you run commands in a pseudo terminal, so you
	       can trick things into running interactively, by using the
	       zsh/zpty module.
	
	       Arguments are parsed similar to 'eval'.
	EOM_help
}

pty() {
	zmodload zsh/zpty
	zpty pty-${UID} ${1+$@}
	if [[ ! -t 1 ]];then
		setopt local_traps
		trap '' INT
	fi
	zpty -r pty-${UID}
	zpty -d pty-${UID}
}

ptyless() {
	pty $@ | less -R
}
