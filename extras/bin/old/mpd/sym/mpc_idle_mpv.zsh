#!/bin/zsh

# vim: fdm fdl=0
# set -x

# {{{ help
[[ $1 =~ '^(-?h|(--)?help)$' ]] && {
	cat <<-EOM
		Usage: $0 [ -hrluxqv ] [ -Oo {HOST} ]
		   Priority: hlu[oO]r
		  -h, --help  show this message and exit
		  -r          run local program
		  -o HOST     enable HOST
		  -O HOST     enable only HOST
		  (Pass -[oO][oO-] to automatically choose localhost
		  -l          list variable data
		  -u          force update by toggling output 'dummy'
		  -U
		  -x
		  -q          run quietly
		  -v          run verbosely (default behavior)
	EOM
	exit 0
}
# }}}

# {{{ getopts
mode_r=false
[[ -z $1 ]] && mode_r=true
mode_o=false
mode_O=false
mode_l=false
mode_u=false
mode_U=false
mode_x=false
mode_v=true
while getopts 'rRo:O:luUxqv' opt ; do
	case $opt in
		r)
			mode_r=true
			;;
		o)
			mode_o=true
			target="$OPTARG"
			;;
		O)
			mode_o=true
			mode_O=true
			target="$OPTARG"
			;;
		l)
			mode_l=true
			;;
		u)
			mode_u=true
			;;
		U)
			mode_U=true
			;;
		x)
			mode_x=true
			;;
		v)
			mode_v=true
			;;
		q)
			mode_v=false
			;;
	esac
done
[[ $opt == : ]] && {
	#TODO
	echo "something is wrong, i think?"
	exit 3
}
# }}}

# {{{ get variable data
# {{{ host
if [[ -z $MPDA_HOST ]] ; then
	if [[ $(uname -o) == Android ]] ; then
		export MPDA_HOST='porygon'
		# export MPDA_HOST='phone'
	else
		MPDA_HOST="$(hostname)"
	fi
else
	MPDA_HOST="$MPDA_HOST"
fi
# }}}
# {{{ port
# These hostnames and ports are hardcoded
# into my MPD config.
case $MPDA_HOST in
	porygon|phone)
		MPDA_HOST="porygon"
		MPDA_PORT=48001
		;;
	bronzor)
		MPDA_PORT=48002
		;;
	turtwig)
		MPDA_PORT=48003
		;;
	lan)
		MPDA_PORT=48000
		;;
	*)
		exit 1
		;;
esac
# }}}
MPDA_URL="http://$MPD_HOST:$MPDA_PORT/mpd.ogg"
# }}}

$mode_v && redir=/dev/stdout
$mode_v || redir=/dev/null

if false ; then
elif $mode_x ; then # {{{
	> $redir {
		mpc pause
		mpc enable only dummy
	}
# }}}
elif $mode_l ; then # {{{
	echo "# These are already quoted by the shell."
	echo "MPDA_HOST=${(q)MPDA_HOST}"
	echo "MPDA_PORT=${(q)MPDA_PORT}"
	echo "MPDA_URL=${(q)MPDA_URL}"
# }}}
elif $mode_U ; then # {{{ mode u
	echo "THIS IS NOT IMPLEMENTED YET"
	return 3
	> $redir \
		mpc enable dummy
	update_dummy=false
	for i in $(
		mpc outputs \
		| perl -p -e 's/^Output \d+ \((idle_[a-z._-]*?)\) is (?:en)abled$|.*/\1/'
	) ; do
		update_dummy=true
		> $redir {
			mpc disable "$i"
			mpc enable "$i"
		}
	done
	$update_dummy \
	&& > $redir {
		sleep 1
		mpc disable dummy
		mpc enable dummy
	}

# }}}
elif $mode_u ; then # {{{ mode u
	> $redir {
		mpc pause
		mpc disable dummy
		mpc enable dummy
		mpc play
	}
# }}}
elif $mode_o ; then # {{{ mode o
	[[ $target =~ ^[-oO]$ ]] && target="$MPDA_HOST"
	> $redir {
		mpc pause
		$mode_O && mpc enable only "idle_$target"
		$mode_O || mpc enable      "idle_$target"
		mpc play
	}
# }}}
elif $mode_r ; then # {{{ mode_r
	> $redir {
		echo "$MPDA_HOST @ $MPDA_PORT"
		echo "$MPDA_URL"
	}

	# {{{
	# The basic idea is as follows:
	#
	# while true; do
	#       if output $mpda_host is enabled;
	#           mpv $mpda_url
	#       mpc idle output update
	# done
# }}}

	# trap_sigint_idle() {
	# 	> $redir \
	# 		print '\nCaught SIGINT while idling!'
	# }

	run_mpv_then_mpc_idle() { # {{{
		if
			> $redir {
				mpc outputs \
				| \grep -E "^Output [0-9]+ \(idle_${MPDA_HOST}\) is enabled$"
			}
		then
			sleep 0.5
			> $redir \
				echo "Output is enabled, running mpv"
			() {
				mpv "$MPDA_URL" \
				--config-dir ~/Dotfiles/extras/mpd
			}
			mpvret=$?
		fi

		setopt LOCAL_TRAPS
		trap $'print \'\nCaught SIGINT while idling.\'' SIGINT
		> $redir {
			echo "Idling..."
			mpc idle output update
			mpcret=$?
		}
		trap -
		[[ $mpcret == 130 ]] && return 0
		return $mpcret
	} # }}}

	# {{{ retry loop
	MAX_RETRY=5
		typeset -i i
		i=0
	for ((i=0;i<=$MAX_RETRY;)) ; do
		if run_mpv_then_mpc_idle ; then
			i=0
			# if [[ $mpcret == 0 ]] ; then
				# > $redir # \
					# && echo "Waking up..."
			> $redir \
				echo "Waking up..."
			sleep 2
			# fi
		else
			(( $i == $MAX_RETRY )) && break
			i+=1
			delay=$((60*($i) ))
			# {{{
			# case ${i[-1]} in
			# 	1) th="st" ;;
			# 	2) th="nd" ;;
			# 	3) th="rd" ;;
			# 	*) th="th" ;;
			# esac
			# echo "Waiting $delay seconds before $i$th retry... (any key to retry now)"
			# }}}
			<<-EOM
			Could not idle. Maybe the host or your network is down?
			Waiting $delay seconds before retrying... ($i/$MAX_RETRY)
			(Press any key to retry now.)
			EOM
			# read with timeout as pseudo-sleep
			while read -k1 -t 0.1 ; do done
			read -s -k1 -t $delay
		fi
	done
	(( $i == 5 )) && {
		echo "Retry count exceeded maximum of $MAX_RETRY"
		return 2
	}
	# }}}
# }}}
elif $mode_v ; then # {{{
	# mpc outputs | perl -p \
	# -e 's/^(Output) (\d+) \((.*?)\) is (?:(en)|dis)abled$/\3\t\4/;' \
	# -e 's/([^ ]+)\ten$/\e[1;32m\1\e[0m/;' \
	# -e 's/^([^ ]+)\t$/\e[1;31m\1\e[0m/;' \
	# | tr -d '\t'
	mpc outputs | perl -p \
	-e 's/^(Output) (\d+) \((.*?)\) is (?:(en)|dis)abled$/\3\t\4/;' \
	| grep -E $'^(dummy|idle_[^\t]*)' \
	| perl -p \
	-e 's/([^ ]+)\ten$/\e[1;32m\1\e[0m/;' \
	-e 's/^([^ ]+)\t$/\e[1;31m\1\e[0m/;' \
	| tr -d '\t'
	echo
	mpc_status
	# }}}
fi
