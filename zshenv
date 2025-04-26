#!/bin/zsh
#
# ~/.zshenv
#

# Thu, Feb 2 2023, 00:02
# Why is this so fucking janky? holy fucking shit this sucks so bad

# only add things to path if we haven't already done so
! [[ $PATH =~ ~/bin ]] && PATH=~/bin/:$PATH
# ! [[ $PATH =~ /snap/bin ]] && PATH=/snap/bin/:$PATH
! [[ $PATH =~ ~/.local/bin ]] && PATH=~/.local/bin/:$PATH
! [[ $PATH =~ ~/.cargo/bin ]] && PATH=~/.cargo/bin/:$PATH
# ! [[ $path =~ ~/bin ]] && path=~/bin/:$path
# this is really stupid, but it puts /usr/local/games first
PATH="${PATH:s/\/usr\/games:\/usr\/local\/games/\/usr\/local\/games:\/usr\/games/}"



### general environment variables ###

export EDITOR=nvim
export PAGER=~/bin/lesser

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export BROWSER=firefox
export WWW_HOME='https://duckduckgo.com/lite/'

export MPC_FORMAT='[[%artist% - ][%album% - ]%title%]|%file%'

export PYTHONSTARTUP=~/.config/python/pythonrc
export PYTHONPATH=~/.config/python/lib
export PYTHON_BASIC_REPL=1

export RUSTC_WRAPPER=sccache



### stranger environment variables ###

export zdate='${(%)$(<<<%D{%Y%m%d_%H%M%S})}'

# envvar to allow for android-specific configs
[[ $(uname -o) == Android ]] || export MyAndroid=false
[[ $(uname -o) == Android ]] && export MyAndroid=true

$MyAndroid && export MPD_HOST=10.0.0.100

if [[ $USER != root ]] && ! $MyAndroid && which firefox >/dev/null ; then
FAKE_USER_AGENT="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:$(firefox -version | cut -d ' ' -f 3)) Gecko/20100101 Firefox/$(firefox -version | cut -d ' ' -f 3)"
fi
