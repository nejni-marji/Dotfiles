#!/bin/zsh

# vim: fdl=0

# MPD_HOST=localhost
MPDN_DELAY=2500
MPDN_APP=MPD

# -n is 0 if nonzero len str
[[ -n "$(mpc -f %file% current 2>/dev/null)" ]] \
	&& mpd_on=true || mpd_on=false

setopt HIST_SUBST_PATTERN EXTENDED_GLOB
if ! $mpd_on ; then
	body="${(F@)@:s/(#b)(*)/<i>${match}<\/i>/}"
	notify-send -t $MPDN_DELAY -a $MPDN_APP \
	"Stopped" "$body"
	exit 1
fi

# {{{ functions
mpdnotif_head() {
	mpc -f '[%title%|%file%]' current
}
mpdnotif_body() {
	albumlen="$(mpc find album "$(mpc -f %album% current)" | wc -l)"
	[[ $albumlen -eq 0 ]] && albumdisp=''
	[[ $albumlen -ne 0 ]] && albumdisp="/$albumlen"
	mpc -f '[%artist%[\n<i>%album%</i> (##%track%'"$albumdisp"')]' current \
	| grep -v '^$'

	mpc -f '' status | tail -n+2 | perl -p \
	\
	-e 's/repeat: on/E/;' -e 's/repeat: off/e/;' \
	-e 's/random: on/R/;' -e 's/random: off/r/;' \
	-e 's/single: on/S/;' -e 's/single: off/s/;' \
	-e 's/consume: on/C/;' -e 's/consume: off/c/;' \
	\
	-e 's#^volume: ?([^ ]+) *(.) *(.) *(.) *(.)#\2\3\4\5, \1#;' \
	-e 's/^(ersc), n\/a$/\1/i;' \
	\
	-e 's#^\[(playing|paused)\]\s+(\#\d+/\d+)\s+([\d:]+/[\d:]+)\s+\((\d+%)\)#[\1] \2: \3, \4#;' \
	\
	-e 's#^\[playing\]#<span background="green"> |> </span>#;' \
	-e 's#^\[paused\]#<span background="red"> || </span>#;' \
	\
	| perl -0 -p \
	-e 's/\n(ersc.*$)/ (\1)/i;' \
}
# }}}

head="$(mpdnotif_head)"
body="$(mpdnotif_body)"
if ! [[ -z $@ ]] ; then
	body+="\n${(F@)@:s/(#b)(*)/<i>${match}<\/i>/}"
fi
notify-send -t $MPDN_DELAY -a $MPDN_APP \
"$head" "$body"

