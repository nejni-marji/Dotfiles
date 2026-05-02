#!/bin/bash

SLEEP_FILE=${XDG_CACHE_HOME=~/.cache}/last_known_sleep_time

case $1 in
	set)
		prev_time=$( date --date="${*:2}" +%s ) || exit $?
		echo $prev_time > $SLEEP_FILE
		;;
	*)
		prev_time=$(cat $SLEEP_FILE)
		;;
esac

# avg drift 1:13, in sec
drift_offset=$(( 73*60 ))

sec_per_day=$(( 60 * 60 * 24 ))

modulus=$(( $sec_per_day + $drift_offset ))

curr_time=$( date +%s )

delta_time=$(( $curr_time - $prev_time ))

mod_time=$(( $delta_time % $modulus ))

if [[ $mod_time -le 0 ]] ; then
	>&2 echo 'wakeup time is in the future'
	exit 11
fi

# data log
echo sec_per_day .... $sec_per_day
echo drift_offset ... $drift_offset
echo modulus ........ $modulus
echo prev_time ...... $prev_time
echo curr_time ...... $curr_time
echo delta_time ..... $delta_time
echo mod_time ....... $mod_time
# print mod_time as human-readable
echo mod_time ....... $(units -- "${mod_time}s" hms)

case $HOSTNAME in
	roxy)
		night_color=4000
		day_color=5500
		;;
	terezi)
		night_color=4500
		day_color=6500
		;;
	*)
		night_color=4500
		day_color=6500
		;;
esac

if [[ $mod_time -gt $(( 60*60*13 )) && $mod_time -lt $(( $modulus-60*60*2 )) ]] ; then
	echo nighttime colors
	cmd="gammastep -o -O $night_color"
else
	echo daytime colors
	cmd="gammastep -o -O $day_color"
fi

old_cmd="$(pgrep -a -x gammastep | cut -d' ' -f2-)"

if [[ $cmd != $old_cmd ]] ; then
	pkill -x gammastep
	swaymsg exec -- "$cmd"
fi
