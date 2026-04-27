#!/bin/zsh
#
# ~/.zshenv
#

# only add things to path if we haven't already done so
! [[ $PATH =~ ~/bin ]] && PATH=~/bin/:$PATH
! [[ $PATH =~ ~/.local/bin ]] && PATH=~/.local/bin/:$PATH
! [[ $PATH =~ ~/.cargo/bin ]] && PATH=~/.cargo/bin/:$PATH
PATH="${PATH:s/\/usr\/games:\/usr\/local\/games/\/usr\/local\/games:\/usr\/games/}"

### general environment variables ###
export EDITOR=nvim
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export BROWSER=firefox
export WWW_HOME='https://duckduckgo.com/'
export MPC_FORMAT='[[%artist% - ][%album% - ]%title%]|%file%'
export RUSTC_WRAPPER=sccache

# be careful with swaysock
[[ -v SWAYSOCK ]] || {
	pgrep -x sway >/dev/null &&
	export SWAYSOCK="$(echo $XDG_RUNTIME_DIR/sway-ipc.$UID.*.sock(Om[1]))"
}

# envvar to allow for android-specific configs
[[ $(uname -o) == Android ]] && export MyAndroid=true
