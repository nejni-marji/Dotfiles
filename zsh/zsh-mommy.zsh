#!/bin/zsh

# use a lockfile to enable/disable mommy
ZMOMMY_LOCK=~/.zsh/mommy.lck

# very basic hook setup
autoload -Uz add-zsh-hook || return

# find mommy
if ! [[ -v ZMOMMY_BIN ]] ; then
	if which cargo-mommy >/dev/null 2>/dev/null ; then
		ZMOMMY_BIN=cargo-mommy
	else
		ZMOMMY_BIN=~/.cargo/bin/cargo-mommy
	fi
	# if we don't have an executable mommy, publish a warning
	if ! [[ -x $ZMOMMY_BIN ]] ; then
		echo 'zmommy: unable to find cargo-mommy'
		ZMOMMY_BIN=true
	fi
fi

# zmommy_setup() {
# 	zmommy_lastcmd=$1
# }

# this variable tells mommy what to run. by running true/false, we just force
# the output to be whatever we want as quickly as possible. there is no need to
# get a static mommy binary when you can just point mommy at true/false.
zmommy() {
err=$?
[[ -f $ZMOMMY_LOCK ]] || return
if [[ $err -eq 0 ]] ; then
	CARGO_MOMMYS_ACTUAL=true $ZMOMMY_BIN
else
	CARGO_MOMMYS_ACTUAL=false $ZMOMMY_BIN
fi
}

# add the hook
# add-zsh-hook preexec zmommy_setup
add-zsh-hook precmd zmommy

mommy() {
	if ! [[ -f $ZMOMMY_LOCK ]] ; then
		touch $ZMOMMY_LOCK
		echo 'mommy enabled'
		# add-zsh-hook preexec zmommy_setup
		# add-zsh-hook precmd zmommy
	else
		\rm $ZMOMMY_LOCK
		echo 'mommy disabled'
		# add-zsh-hook -d preexec zmommy_setup
		# add-zsh-hook -d precmd zmommy
	fi
}



# miscellaneous features:

# if you tell mommy "no", she'll go away in that shell
no-mommy() {
	# add-zsh-hook -d preexec zmommy_setup
	add-zsh-hook -d precmd zmommy
}

# if you tell mommy "yes", on the other paw...
yes-mommy() {
	touch $ZMOMMY_LOCK
	# add-zsh-hook preexec zmommy_setup
	add-zsh-hook precmd zmommy
}

# function to unset all of mommy's configurations (for demo purposes)
unset-mommy() {
for i in $(typeset |
	grep '^CARGO_MOMMYS' |
	cut -d= -f1) ; do
		unset $i
	done
}
