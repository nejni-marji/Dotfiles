#!/bin/zsh

{
	wttr_opt="$1"
	wttr_flags="$2"
	[[ -z $3 ]] || wttr_lang="$3."
	[[ -z $wttr_redraw ]] && wttr_redraw="$4"
	[[ -z $wttr_redraw ]] && wttr_redraw="$REDRAW"
	[[ -z $wttr_redraw ]] && wttr_redraw=$((60*15))
	REDRAW="$wttr_redraw" whless.zsh \
	"date '+%A, %B %-d, %H:%M'" \
	'&&' \
	"curl -s --compressed '${wttr_lang}wttr.in/${wttr_opt}?${wttr_flags}'"
}
