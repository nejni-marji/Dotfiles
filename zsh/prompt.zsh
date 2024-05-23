#!/bin/zsh

if ! $MyAndroid ; then
setopt PROMPT_SUBST
PROMPT=$'\e[?25h''$(color_clock.zsh)
%B%(!.%F{black}%K{red}.%F{white}%K{blue})s%Le%? %n@%M%b%k
%F{cyan}%5~%f
%F{cyan}%(!.#.🐚) %f'

else
PROMPT='%F{black}%K{green}%D{%a, %b %-d, %H:%M:%S}%f%k
%B%(!.%F{black}%K{red}.%F{white}%K{blue})s%Le%? %n@%M%b%f%k
%F{cyan}%5~%f
%F{cyan}%(!.#.🐚) %f'

fi

if [[ $ASCII_ONLY =~ '^(yes|on|true|1)$' ]] ; then
	PROMPT=${PROMPT:s/🐚/%%/}
	woof() {
		< ~/Dotfiles/extras/woof.txt
	}
fi



# adding an "Unregistered HyperCam 2" watermark to my terminal!
#
# ansi codes via https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
# 7 is save
# H is go to 0,0
# 47;1;30m is colors
# 0m is no formatting
# 8 is restore
prompt_hc2=$'%{\e7\e[H\e[47;1;30mUnregistered HyperCam 2\e[0m\e8%}'
prompt_hc2_lock=~/.zsh/hc2.lck
prompt_hc2_base=$PROMPT

hc2() {
	if [[ $PROMPT == $prompt_hc2_base ]] ; then
		touch $prompt_hc2_lock
		PROMPT+=$prompt_hc2
		echo 'hc2 watermark enabled'
	else
		[[ -f $prompt_hc2_lock ]] && \
		rm $prompt_hc2_lock
		PROMPT=$prompt_hc2_base
		echo 'hc2 watermark disabled'
	fi
}

if [[ -f $prompt_hc2_lock ]] ; then
	# bitbucket to hide text, echo to add a line to not break the first prompt
	hc2 >/dev/null
	echo
fi




# deprecating jankier systems for one that only checks if i'm root
# -2022-05-08 10:36:49
#
# if ! $MyAndroid ; then
# setopt PROMPT_SUBST
# PS1='$(color_clock.zsh)
# %B%(1000#.%F{white}%K{blue}.%F{black}%K{red})s%Le%? %n@%M%b%k
# %F{cyan}%5~%f
# %F{cyan}%(!.#.🐚) %f'
# PS1='$(color_clock.zsh)
# %B%(1000#.%F{white}%K{blue}.%F{black}%K{red})s%Le%? %(1000#.lexa.%n)@%M%b%k
# %F{cyan}%5~%f
# %F{cyan}%(!.#.🐚) %f'

# else
# MyAndroidUser=10197
# PS1='%F{black}%K{green}%D{%a, %b %-d, %H:%M:%S}
# %B%('"$MyAndroidUser"'#.%F{white}%K{blue}.%F{black}%K{red})s%Le%? %('"$MyAndroidUser"'#.lexa.%n)@%M%b%k
# %F{cyan}%5~%f
# %F{cyan}%(!.#.🐚) %f'
# fi

# PS1+=$prompt_hc2
