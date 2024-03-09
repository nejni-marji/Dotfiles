#!/bin/zsh

# very basic hook setup
autoload -Uz add-zsh-hook || return

# find mommy
if ! [[ -v ZSH_MOMMY_BIN ]] ; then
	if which cargo-mommy >/dev/null 2>/dev/null ; then
		ZSH_MOMMY_BIN=cargo-mommy
	else
		ZSH_MOMMY_BIN=~/.cargo/bin/cargo-mommy
	fi
	# if we don't have an executable mommy, publish a warning
	if ! [[ -x $ZSH_MOMMY_BIN ]] ; then
		echo 'zsh-mommy: unable to find cargo-mommy'
		ZSH_MOMMY_BIN=true
	fi
fi

# this variable tells mommy what to run. by running true/false, we just force
# the output to be whatever we want as quickly as possible. there is no need to
# get a static mommy binary when you can just point mommy at true/false.
zsh-mommy() {
if [[ $? -eq 0 ]] ; then
	CARGO_MOMMYS_ACTUAL=true $ZSH_MOMMY_BIN
else
	CARGO_MOMMYS_ACTUAL=false $ZSH_MOMMY_BIN
fi
}

# add the hook
add-zsh-hook precmd zsh-mommy

# miscellaneous features:

# function to unset all of mommy's configurations (for demo purposes)
unset-mommy() {
for i in $(typeset |
	grep '^CARGO_MOMMYS' |
	cut -d= -f1) ; do
		unset $i
	done
}