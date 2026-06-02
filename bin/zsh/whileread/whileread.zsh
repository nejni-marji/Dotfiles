#!/bin/zsh
# set -x

local -a AT=("$@")
[[ -z $REDRAW ]] && REDRAW=$((60*15))

# F=$0
F=${0%.zsh}
# F=${${0:A:t}%.zsh}

inner() {
	eval "${(@)AT}"
}

# Notes - 2019-07-24 21:01:54
#
# The job-kill method could theoretically be made into its
# own function, individual to each method, rather than
# being forcefully embedded into the outer_func() command.
# This would be smart, and technically I could declare that
# the redraw_func() be run as a job at the end of the
# script, thereby making the job-kill command be generic
# to all methods.
# However, I can't be bothered to give a shit to implement
# anything completely right now, so REDRAW is only useful
# for less-mode operation.
#
# Future me, if this annoys you: I'm sorry.
#
# Weather update:
# You can't really see 'read' statements from... wait, but
# I call bash's 'read'.
# Either way, I should be implementing REDRAW into the
# -t flag for 'read'. So, cleanup_func can be used for
# anything I might want to do, and otherwise be aliased.
#
# Yeah, so... ultimately, how it currently is, that's
# probably what's best for it.

case "$F" in
	*less)
		# espeak "less mode" &>/dev/null &
		outer_func() {
			tput reset
			# job to defeat metal gear (redraw after timer)
			{
				sleep $REDRAW
				pkill -fx -P $$ 'less -R'
			} &
			inner | less -R
		}

		cleanup_func() {
			# if metal gear died on its own, kill snake
			[[ -n $jobstates ]] && kill ${${jobstates##*:*:}%=*}
			# Disabling this because it's slow. Uncomment it if whless.zsh
			# reloads the display two times right in a row. - 2019-08-25 15:54:31
			# sleep 2
			[[ -n $jobstates ]] && kill ${${jobstates##*:*:}%=*}
		}

		logic_func() {
			bash -c 'read -s -t 2'
			e=$?
			[[ $e == 1 ]] && return 1
			return 0
		}
	;;
	*tput|*read)
		# espeak "less mode" &>/dev/null &
		outer_func() {
			tput reset
			inner
		}

		alias cleanup_func=true
		logic_func() {
			bash -c "read -s -t $REDRAW"
			e=$?
			[[ $e == 1 ]] && return 1
			return 0
		}
	;;
	*)
		>&2 {
			echo "Bad filename"
			echo "\$0: ${(q-)0}"
			echo "\$F: ${(q-)F}"
		}
		exit 1
	;;
esac

outer_func
cleanup_func
while logic_func ; do
	outer_func
	cleanup_func
done
# sleep 1
# espeak 'final cleanup'
cleanup_func
