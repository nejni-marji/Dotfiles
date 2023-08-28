#!/bin/zsh

title_command_ignore=(cd echo cl ls)

set_ansi_title() {
	# printf '%s\n' "$1"
	\printf '\033]0;%s\007' "$1"
}

set_ansi_title_command() {
	cmd_arr=(${(A)${(z)1}})
	ansi_title="${cmd_arr[1,3]}"
	set_ansi_title "$ansi_title"
}

set_ansi_title_prompt() {
	ansi_title="${(%)$(\echo '%~')}"
	if [[ $ansi_title == '~' ]] ; then
		ansi_title="${(%)$(\echo '%n@%m')}"
	fi
	set_ansi_title "$ansi_title"
}

set_ansi_title_enable() {
	add-zsh-hook preexec set_ansi_title_command
	add-zsh-hook precmd set_ansi_title_prompt
}

set_ansi_title_disable() {
	add-zsh-hook -d preexec set_ansi_title_command
	add-zsh-hook -d precmd set_ansi_title_prompt
	set_ansi_title_prompt
}

set_ansi_title_enable
