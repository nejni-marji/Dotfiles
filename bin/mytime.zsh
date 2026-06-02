#!/bin/zsh

if [[ $1 =~ '-h|help' ]] ; then
	echo 'mytime.zsh UNTIL SINCE [OPTS]'
	exit 0
fi

# store dates
d1="${1:-now}"
d2="${2:-now}"

# print "$d2 - $d1"
# print "diff: $diff"

diff=$(( $(date +%s --date "$d1") - $(date +%s --date $d2) ))

# if OPTS==sec, show seconds delta instead of D:HH:MM:SS
if [[ $3 == "sec" ]] ; then
	print "$diff"
	exit 0
fi

# if diff < 0; invert it and set sign to negative
if [[ $diff -lt 0 ]]; then
	sgn='-'
	diff=$(( -1 * $diff))
fi

# print "diff: $diff"
# print "sgn:  $sgn"

# modulo by size of next largest unit and divide by smaller one
d=$(( $diff              / (24*60*60) ))
h=$(( $diff % (24*60*60) / (60*60)    ))
m=$(( $diff % (60*60)    / 60         ))
s=$(( $diff % 60                      ))

# $sgn in quotes because it may be empty
printf '%s%i:%02i:%02i:%02i\n' "$sgn" $d $h $m $s
