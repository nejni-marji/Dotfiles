#!/bin/zsh

# This is under the ISC License (due to including code from zbell.sh) i guess

## general preamble

# include
autoload -Uz add-zsh-hook || return
zmodload zsh/datetime || return

# program vars
ZMOMMY_LOCK=~/.zsh/mommy.lck

if ! [[ -v ZMOMMY_BIN ]] ; then
	if which cargo-mommy >/dev/null 2>/dev/null ; then
		ZMOMMY_BIN=cargo-mommy
	else
		ZMOMMY_BIN=~/.cargo/bin/cargo-mommy
	fi
	# if we don't have an executable mommy, publish a warning
	if ! [[ -x $ZMOMMY_BIN ]] ; then
		echo 'zmommy: unable to find cargo-mommy'
		return
	fi
fi

# duration is seconds, random is a percentage 0-100
[[ -v zmommy_duration ]] || zmommy_duration=5
[[ -v zmommy_random   ]] || zmommy_random=-1
[[ -v zmommy_include  ]] || zmommy_include=(true false)
[[ -v zmommy_exclude  ]] || zmommy_exclude=(ls cd echo print)



## program hooks

# preexec hook
zmommy_timestamp=$EPOCHSECONDS
zmommy_pre() {
	zmommy_timestamp=$EPOCHSECONDS
	zmommy_lastcmd=$1
}

# precmd hook
zmommy_post() {
	err=$?
	# set -x
	[[ -f $ZMOMMY_LOCK ]] || return
	[[ $err -eq 0 ]] && zmommy_actual=true || zmommy_actual=false

	# the following logic was copied from:
	# https://gist.github.com/oknowton/8346801 (zbell.sh)
	# and is under the ISC License.
	# some modifications have been made by me.

	has_zmommy_duration=false
	if (( $EPOCHSECONDS - $zmommy_timestamp >= $zmommy_duration )); then
		has_zmommy_duration=true
	fi

	has_zmommy_exclude_cmd=false
	for cmd in ${(s:;:)zmommy_lastcmd//|/;}; do
		words=(${(z)cmd})
		util=${words[1]}
		if (( ${zmommy_exclude[(i)$util]} <= ${#zmommy_exclude} )); then
			has_zmommy_exclude_cmd=true
			break
		fi
	done

	has_zmommy_include_cmd=false
	for cmd in ${(s:;:)zmommy_lastcmd//|/;}; do
		words=(${(z)cmd})
		util=${words[1]}
		if (( ${zmommy_include[(i)$util]} <= ${#zmommy_include} )); then
			has_zmommy_include_cmd=true
			break
		fi
	done

	has_zmommy_random=false
	if (( RANDOM % 100 < $zmommy_random )); then
		has_zmommy_random=true
	fi

	# conditionals on logic
	$has_zmommy_exclude_cmd &&
		return
	! { $has_zmommy_include_cmd ||
		$has_zmommy_duration ||
		$has_zmommy_random } &&
		return

	# [end copied logic]

	# actually run mommy
	CARGO_MOMMYS_ACTUAL=$zmommy_actual $ZMOMMY_BIN
}

# add the hooks
add-zsh-hook preexec zmommy_pre
add-zsh-hook precmd zmommy_post



## control functions

# basic mommy toggle
mommy() {
	if ! [[ -f $ZMOMMY_LOCK ]] ; then
		touch $ZMOMMY_LOCK
		echo 'mommy enabled'
	else
		\rm $ZMOMMY_LOCK
		echo 'mommy disabled'
	fi
}

# if you tell mommy "no", she'll go away in that shell
no-mommy() {
	add-zsh-hook -d preexec zmommy_pre
	add-zsh-hook -d precmd zmommy_post
}

# if you tell mommy "yes", on the other paw...
yes-mommy() {
	touch $ZMOMMY_LOCK
	add-zsh-hook preexec zmommy_pre
	add-zsh-hook precmd zmommy_post
}

# function to unset all of mommy's configurations (for demo purposes)
unset-mommy() {
for i in $(typeset |
	grep '^CARGO_MOMMYS' |
	cut -d= -f1) ; do
		unset $i
	done
}
