#!/bin/zsh

get_ppid_proc() {
	[[ $1 -le 1 ]] && return 1
	ps --no-headers -o ppid "$1" | tr -cd '0-9\n'
}

get_ppid_list() {
	pid=$1
	[[ $pid -le 1 ]] && pid=$$
	while true ; do
		echo "$pid"
		pid=$(get_ppid_proc $pid) || break
	done
}

FMT='uname,pid,stime,time,cmd'

get_ppid_tree() {
	ps -o "$FMT" 1 | head -n1
	for pid in $(get_ppid_list "$1" | tac) ; do
		ps --no-header -o "$FMT" $pid
	done
}

case "$1" in
	p|-p)
		get_ppid_proc "$2"
		;;
	P|-P)
		get_ppid_list "$2"
		;;
	t|-t)
		get_ppid_tree "$2"
		;;
	h|-h|--help|help)
		# >&2 <<< "Usage: ${0} [arg] PID"
		>&2 <<< "Usage: ${0:t} [arg] PID"
		# >&2 <<< "Usage: ${0:t:r} [arg] PID"
		>&2 <<-"EOM"
			       p ---> parent process
			       P|* -> parent list
			       t ---> ps-style list
			       h ---> help
		EOM
		exit 0
		;;
	*)
		get_ppid_list "$1"
		;;
esac
