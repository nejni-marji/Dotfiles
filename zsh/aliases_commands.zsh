#!/bin/zsh

###############
### ALIASES ###
###############

# janky shit

my-sshfs() {
	case $1 in
		home)
			host_addr=home
			host_ssh=turtwig-home
			;;
		turtwig|*)
			host_addr=turtwig
			host_ssh=turtwig
			;;
	esac

	dir=/media/$USER/remote

	mountpoint -q $dir || {
		while ! ping -c1 $host_addr ; do
			sleep 1
		done
		sshfs $host_ssh:/ $dir
	}

	cd "$dir/.$HOME" || cd $dir
}

alias notepad=leafpad

alias cargo='RUSTC_WRAPPER=sccache cargo mommy'

sudo() {
	if [[ $1 == apt ]] ; then
		real_apt=$(zsh -c 'which apt')
		if ! [[ $real_apt =~ 'not found' ]] ; then
			$real_apt $@
		else
			echo 'you dumbass' | figlet
		fi
		# unset real_apt
	elif [[ $1 == apt-get ]] ; then
		real_apt_get=$(zsh -c 'which apt-get')
		if ! [[ $real_apt_get =~ 'not found' ]] ; then
			$real_apt_get $@
		else
			echo 'you dumbass' | figlet
		fi
		# unset real_apt_get
	else
		real_sudo=$(zsh -c 'which sudo')
		$real_sudo $@
		# unset real_sudo
	fi
}

apt() {
	real_apt=$(zsh -c 'which apt')
	if ! [[ $real_apt =~ 'not found' ]] ; then
		$real_apt $@
	else
		echo 'you dumbass' | figlet
	fi
	# unset real_apt
}

alias resume='node ~/node_modules/resume-cli/build/main.js'

heyuber() {
	date --date="$1" "+hey uber remind me at %H:%M %z on %Y/%m/%d to $2" \
		| tee >(perl -pe chomp | wl-copy -n)
	echo 'Copied to clipboard!'
}

fadeout() {
	pactl list sink-inputs | \grep -Pi 'Sink Input|(media\.name|application\.name)'
	read '?Select a sink input: ' sinkinput
	echo 'Temporarily muting to check if this is the correct audio.'
	pactl set-sink-input-mute $sinkinput toggle
	sleep 1
	echo 'Unmuting.'
	pactl set-sink-input-mute $sinkinput toggle
	read '?Was this correct? [Y/n] ' yn
	[[ $yn =~ 'y|yes' ]] || return 1
	for ((i=100;i>=0;i--)) ; do
		echo ${i}%
		pactl set-sink-input-volume $sinkinput ${i}%
		sleep 1.2
	done
}

mpv-autoplay() {
	file=$1
	file=${file%.part}
	while ! [[ -f $file ]] ; do sleep 5 ; print -n . ; done
	print
	mpv --fullscreen $file
}

do_a_crime() {
	yt-dlp -f ba $@ -- 'ytsearch:weird al dont download this song'
}



###################################
### aliases for common programs ###
###################################

# think 'll', 'ydl'. stuff that wraps over one program

# ls
export QUOTING_STYLE=literal
alias l='ls'
alias ls='ls -F --color=auto --group-directories-first'
alias ll='ls -l'
alias la='ls -A'
alias laa='ls -a'
alias lla='ls -lA'
alias llaa='ls -la'
alias lr='ls -R'
alias llr='ls -lR'
alias lsd='ls -d'

# git aliases
alias g='git'
alias gs='git status'
alias gss='git status --short'
alias gd='git diff'
alias gsv='git status -v'
alias gdv='git diff -v'
alias gsh='git stash'
alias ga='git add'
alias gaa='git add -A'
alias gcm='git commit -m'
alias gpu='git push'
alias gch='git checkout'
alias gl='git log --color --decorate --oneline'
alias glh='git log --color --decorate --oneline | head'
# return to root of git-managed dir
alias gr='git rev-parse --show-toplevel >/dev/null && cd $(git rev-parse --show-toplevel)'

# anything that aliases over an existing program
alias grep='grep --color=auto'
alias rsync='rsync -hva --old-args'
alias diff='diff --color=auto'
alias df='df -x tmpfs -x devtmpfs -x squashfs -lh --output=target,size,used,avail,pcent'
alias python='python3'
alias rm='echo pls dont' # alias over rm because i dont use it
alias nl='nl -ba -ha -fa -p -n ln'
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'
alias cringename='basename'
alias paru='paru --sudoflags --bell'
alias todo='todo.sh'
alias calc='units'

# same as above, but for less standard programs
alias units='units -v'
local -a GAYFLAGS=(--trans --nb --genderfluid --demigirl --gay --lesbian)
alias gay='gay -i 2d --black "#404040" "${GAYFLAGS[($RANDOM % ${#GAYFLAGS[@]})+1]}"'
alias gay='gay -i 2d --white "#e0e0e0" --black "#404040" "${GAYFLAGS[($RANDOM % ${#GAYFLAGS[@]})+1]}"'
# alias gay='gay -i 2d --white "#ffffff" --black "#000000" "${GAYFLAGS[($RANDOM % ${#GAYFLAGS[@]})+1]}"'
if [[ $USER != root ]] && ! $MyAndroid && which firefox >/dev/null ; then
local FF_VER=$(firefox -version | cut -d' ' -f3)
fi
alias mpv-web="mpv --user-agent=\"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:$FF_VER) Gecko/20100101 Firefox/$FF_VER\""
unset FF_VER

# abbreviations for existing programs
alias wcl='wc -l'
alias x='xargs -I {}'
############################################################
# youtube-dl \
# 	--restrict-filenames \
# 	--write-sub --write-auto-sub \
# 	--sub-lang en,en-US,en-GB,en-CA \
# 	-f 'bestvideo[height<=1080]+bestaudio' \
# 	-o '%(title)s.%(id)s.f%(format_id)s.%(ext)s' \
# 	--socket-timeout 1 --retries infinite \
# 	--external-downloader aria2c \
# 	--external-downloader-args '-x 16 -s 16 -k 1M'
############################################################
# # normal get
# alias ydl="youtube-dl --restrict-filenames --write-sub --write-auto-sub --sub-lang en -f 'bestvideo[height<=1080]+bestaudio/best' -o '%(title)s.%(id)s.f%(format_id)s.%(ext)s' --socket-timeout 1 --retries infinite --external-downloader aria2c --external-downloader-args '-x 16 -s 16 -k 1M'"
# # get with autonumber
# alias ydlpl="ydl -o '%(autonumber)03d_%(title)s.%(id)s.f%(format_id)s.%(ext)s'"
# # automatically create folders for author and series name
# alias ydlplauto="ydl -o '%(channel)s/%(playlist)s/%(autonumber)03d_%(title)s.%(id)s.f%(format_id)s.%(ext)s'"
# # show extractor
# alias ydle="ydl -o '%(extractor)s_%(title)s.%(id)s.f%(format_id)s.%(ext)s'"
# # legacy alias
# alias ydlsubs='ydl'

# Mon, Jan 30 2023, 22:41
# I have abandoned youtube-dl in favor of yt-dlp. Here are new aliases to match.
alias ydl="yt-dlp --no-playlist --write-subs --write-auto-subs --sub-lang en -f 'bv[height<=1080]+ba/b'"

alias subs='subliminal download -l en'



# for typos
alias ccl='cl'
alias gerp='grep'



##################################
### aliases for my own scripts ###
##################################

# audio stuff
alias a=audio.zsh
alias btw='a bt;exit'

# water unit system lmao
alias water='units -f $(units -U) -f ~/Dotfiles/extras/water.units -u water'

# vimhelp stuff
# alias vih=vimhelp
# alias nvih=vih
# alias hvim=vih
alias vh=vimhelp



#######################################
### aliases of convenience or typos ###
#######################################

# miscellaneous shell stuff
alias freq='sort -n | uniq -c | sort -n'
alias freql='sort -n | uniq -c | sort -nr | less'
alias data='du -hs -- *(D) 2>/dev/null | sort -hr'
alias datag="data | grep 'G\s'"
alias datadot='du -hs * .* 2>/dev/null | sort -hr'
alias alarm='echo -ne "\a"'

alias chomp='perl -pe chomp'
alias afold='fold -sw $COLUMNS'
# ufold is afold but it's supposed to crop the top of the file to how many lines
# can be displayed at the same time as $PROMPT
alias ufold='fold -w $COLUMNS | head -n  $(($LINES-0-${#${(f@)PROMPT}}))'

# pseudo-constants, i guess??? i didnt really think these through that much
alias COPY='wl-copy -n'
alias PASTE='wl-paste -n'
alias BAR="printf '%0.s#' {1..\$COLUMNS} ; print"
TRIM() { PASTE | perl -pe 's/^\s*//' | COPY }

# vim exits
alias :q='exit'
alias :qa='exit'

# c++ compile and testing, kinda buggy honestly
alias caout='g++ *.cpp && ./a.out'

# fix deadname (relies on shell file)
alias deadname='perl -p ~/Dotfiles/extras/.deadname_re'



######################
### END OF ALIASES ###
######################


#################
### FUNCTIONS ###
#################

# WIP

get-remote() {
	case $HOST in
		turtwig)
			echo bronzong
			;;
		bronzong)
			if ping -c1 turtwig >/dev/null 2>/dev/null ; then
				echo turtwig
			else
				echo home
			fi
			;;
	esac
}

mpc-sync() {
	MY_REMOTE=$(get-remote)
	data="$(ssh $MY_REMOTE cat ~/.config/mpd/state)"
	mpc -h $MY_REMOTE pause
	systemctl --user stop mpd
	echo $data >! ~/.config/mpd/state
	systemctl --user start mpd
	mpc play
}

mpc-duration() {
PREFIX=~/Music/
for track in "${(f)$(mpc -f %file% playlist)}" ; do
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${PREFIX}${track}"
done | paste -sd+ | x units '({})s' hms
}



################################
### functions of convenience ###
################################

# functions that wrap around an existing program

ssh() {
	# scrape valid hosts from the ssh config
	hosts=( $(
		< ~/.ssh/config |
			grep -Po '^[^#]+' |
			grep -Po '(?<=Host\s)\S+'
		) )
	# check if $1 is in $hosts
	if [[ $#@ -eq 1 ]] && [[ ${hosts[(i)$1]} -le $#hosts ]] ; then
		echo 'using mosh instead of ssh'
		mosh $1
	else
		# use a subshell to get the real ssh path
		real_ssh=$(zsh -c 'which ssh')
		# $@ are *all* positional arguments, at once
		$real_ssh $@
		# unset real_ssh
	fi
}



# self explanatory functions

cl() {
	local dir="$1"
	local dir="${dir:=$HOME}"
	if [[ -d "$dir" ]]; then
		cd "$dir" >/dev/null; ls
	elif [[ "$dir" = "-" ]]; then
		cd -; ls
	else
		echo "zsh: cl: $dir: Directory not found"
	fi
}

timer() {
	TIMER=$((60*$1))
	echo $TIMER
	while [[ $TIMER > 0 ]]; do
		sleep 1
		TIMER=$(($TIMER-1))
		echo $TIMER
	done
	echo -e '\a'
}

timer2() {
	# Set variables
	alarm_raw=$1
	delay=$2
	[[ -z $delay ]] && delay=60
	# Calculate dates
	alarm_sec=$(date --date $alarm_raw '+%s')
	alarm_date=$(date --date="@$alarm_sec" "+$date_fmt")
	date_fmt='%a, %b %d, %T'
	# Core loop
	while true ; do
		# Get current dates
		now_sec=$(date '+%s')
		now_date=$(date --date="@$now_sec" "+$date_fmt")
		# Show calculations
		echo "Comparing..."
		echo "Now:   $now_date"
		echo "Alarm: $alarm_date"
		# Check if we have surpassed the alarm time
		[[ $now_sec -ge $alarm_sec ]] && break
		# Wait for a while before checking again
		sleep $delay
	done
	# Once done, make a big obvious printout
	for ((i=0;i<10;i++))
		echo '!!! ALARM HAS BEEN REACHED !!!'
}

teetmp() {
	TEETMP_NAME="$(\echo "$1" | tr -d '\n' | tr -c '[:alnum:]' '_')"
	# TEETMP_FILE="$(mktemp -u -p. teetmp."$TEETMP_NAME".${(e)zdate}.XXXXXXXXXX)"
	TEETMP_FILE="$(mktemp -u -p. "$TEETMP_NAME".${(e)zdate}.XXXXXXXXXX)"
	\echo "$TEETMP_FILE" >&2
	tee "$TEETMP_FILE"
	unset TEETMP_NAME TEETMP_FILE
}

cdtmp() {
	if [[ $1 =~ '^(-?h|(--)?help)$' ]] ; then
		>&2 echo 'Usage: cdtemp TAG PATH'
		return 0
	fi
	pushd "$(mktemp -d -p "${2:-"."}" "tmp${1:+".$1"}.$(date '+%Y%m%d_%H%M%S').XXXXXXXXXX")"
}

# TODO: rename me!!!
pingwait() { while ! ping -c 1 $1 ; do sleep 1 ; done ; espeak "resolved $1" }
pingwait2() { while ! ping -c 1 $1 ; do sleep 1 ; done ; espeak "resolved $1" ; ping $1 }
pingwait3() {
	errPrev=1
	while true ; do
		ping -c1 $1 >/dev/null
		err=$?
		#typeset err errPrev
		if [[ $err != $errPrev ]] ; then
			case $err in
				0)
					resp="connected to $1"
					;;
				1)
					resp="disconnected from $1"
					;;
			esac
			echo "[$(date)]"
			echo $resp
			espeak $resp
		fi
	errPrev=$err
	sleep 5
	done
}

pacman-list-manual() {
	comm -23 \
		<(pacman -Qqen) \
		<({
			pactree -l base
			pacman -Qg | grep '^base-devel' | cut -d' ' -f2
		} | sort | uniq)
}

syncthing-stversions() {
	# if ! [[ -v MySyncthingVersions ]] ; then
	# 	echo '[INFO] Searching for .stversions folders...' >&2
	# 	# typeset -a -g MySyncthingVersions=( $(find . -name .stversions 2>/dev/null) )
	# fi
	# du -chs $MySyncthingVersions
	du -chs $(locate ~/\*/.stversions)
}



# functions that are convenient because i know what they do

tg-fix() {
	file=( ~/Downloads/Telegram\ Desktop/*.mp4(om[1]) )
	out=${file:h}/${${file:t}:r}.fix.${${file:t}:e}
	ffmpeg -i ${file} $out
	echo ${out:a} | COPY -n
}

mc-screenshot() {
	xclip -se c -t image/png -i ~/.minecraft/screenshots/*(#q[-1])
}

ocr-copy() {
	mpc
	data=$(mpc -f '%track%\t%album%' current)
	echo $data |
	grep -P '\tocremix.org$' >/dev/null &&
	track=$(echo $data |
	cut -f1) &&
	printf 'https://ocremix.org/remix/OCR%05i' $track |
	wl-copy
}

music-upload() {
	data=$(mpc -f %file% current) &&
	echo ~/Music/"$data" |
	tee /dev/stderr |
	wl-copy -n
	if [[ "$data" =~ 'OC ReMix Collection - General' ]] ; then
		ocrnum="$(ffprobe -loglevel quiet -show_entries format -of json ~/Music/"$data" | jq -r '.format.tags | [.setsubtitle, .SETSUBTITLE][] | values')"
		ocrurl="https://ocremix.org/remix/$ocrnum"
		echo $ocrurl |
		tee /dev/stderr |
		wl-copy -n
	fi
}

file-upload() {
	echo ${1:A} |
	tee /dev/stderr |
	wl-copy -n
}

# this used to be a bash script, so it's keeping the same name
unzip.sh() {
	unzip "$1" -d "${1%.zip}"
}

# functions that would be convenient if i knew what they did

whiledo() {
	clear
	eval "$@"
	while read
	do clear
	eval "$@"
	done
}

rs() { redshift -Pvo -t "${1-4500}:${1-4500}" -b "${2-1}:${2-1}" }

vimhelp() {
	nvim -s <(<<<":help $1 | only")
}

hgrep() {
	[[ $1 =~ ^[0-9]+$ ]] || return $?
	n=$1; shift
	awk -v "n=$n" 'NR <= n { print > "/dev/stderr" }; NR == n { print "" > "/dev/stderr" }; NR > n' |
		grep "$@"
}

rstat() {
	[[ -z $1 ]] && return 1
	ssh riolu \
		journalctl \
		-q \
		--no-pager \
		-n $(($LINES/3)) \
		--user-unit="$1" \
		"${@[2,-1]}"
}

# These used to be in "functions that could be scripts"

mpv-screenshot-search() {
	find ~/Pictures/MPV_Screenshots \
		| sort \
		| grep -Pi "$1" \
		| perl -pe 's#^/(?:[^/]+/){4}(?:.{29})(\d{2})h(\d{2})m(\d{2})s\d{3}-\d{4}-(.*)\.jpg#\1:\2:\3\t\4#g' \
		| tail -n5 \
		| grep -Pi --color=auto "$1"
}

mcopy() {
	file=~/Music/"$(mpc -f %file% current)"
	echo ${file:a} | wl-copy -n
	echo "Copied to clipboard!"
}

msticker() {
	mpc sticker "$(mpc -f %file% current)" $@
}

mrating() {
	if [[ -v 1 ]] ; then
		mpc sticker "$(mpc -f %file% current)" set rating $1
	else
		mpc sticker "$(mpc -f %file% current)" get rating
	fi
}

msettings() {

	# $1 is ERsc [crossfade?]
	if [[ ${1:l} =~ 'ersc' ]] ; then
		local -a modes=(repeat random single consume)
		for ((i=1;i<=4;i++)) ; do
			[[ 'ersc' =~ ${1[$i]} ]]
			mpc -q $modes[$i] $?
			echo -n .
			sleep 0.25
		done
		echo
		mpc status |
			tail -n1

	# $1 is unset
	elif ! [[ -v 1 ]] ; then
		local ersc1='ersc'
		local -a ersc2=( $(mpc status |
			tail -n1 |
			grep -Po '(?<=: )(off|on)\b')
		)
		local ersc3=''
		for ((i=1;i<=4;i++))
			[[ $ersc2[$i] == 'on' ]] &&
				ersc3+=${${ersc1[$i]}:u} ||
				ersc3+=$ersc1[$i]
		echo $ersc3
		return 2

	# $1 is error
	else
		echo fail
		return 1
	fi

	# $2 is crossfade
	if [[ -v $2 ]] && [[ $2 =~ '^[0-9]$' ]] ; then
		mpc -q crossfade $2
		sleep 0.25
		mpc crossfade
	fi
}

ri() {
	# ~/bin/regional_indicator.py "${@[@]}" \
	# 	| tr -d '\n' \
	# 	| wl-copy -n
	~/bin/regional_indicator.py "${@[@]}" \
		| wl-copy -n
}

obs-upload() {
	file=( ~/Videos/obs/*.mkv(om[1]) )
	tgt=${file:r}.mp4
	ffmpeg -i "$file" "${file:r}.mp4"
	echo $tgt | wl-copy -n
}

# old functions that i don't use anymore. it's possible that some of these were
# briefly removed from this file, but were brought back for some reason or
# another.

magnus-warnings() {
	if [[ $1 =~ html ]] ; then
		url="$1"
	else
		url="https://snarp.github.io/magnus_archives_transcripts/episode/$1.html"
	fi
	pat=$magnus_triggers
	if ! [[ -z $2 ]] ; then
		pat+="|$2"
	fi
	if [[ $MAGNUS_DEBUG == true ]] ; then
		echo "url: $url" >&2
		echo "pat: $pat" >&2
	fi
	text="$(curl --silent "$url" \
		| grep -Po '(?<=\<p class="spoiler"\>).*(?=\<\/p\>)' \
		| grep -Po '((?<=^)|(?<=, ))([^,]+\([^)]+\)|[^,]+(?=,|$))' \
	)"
	local -a data=("${(f)${text}}")
	local -a warn=("${(f)$(echo $text | grep -Pi "$pat")}")
	local datalen=$#data
	local warnlen=$#warn
	[[ $data == "" ]] && datalen=0
	[[ $warn == "" ]] && warnlen=0
	echo "$warnlen/$datalen"
	! [[ -z $warn ]] && echo "${(F)warn}"
}



####################################
### functions for my own scripts ###
####################################

alias poke=pokeapi

load_pokeapi_functions() {
	pokeapi-height() {
		# units -v1 "$(./pokeapi_get.py "$(./pokeapi_get.py 'pokemon?limit=2000' | jq ".results | .[] | select(.name==\"$1\") | .url" -r)" | jq '.height') decimeters" 'ft;in'
		# units -v1 "$(./pokeapi_get.py "$(./pokeapi_get.py 'pokemon?limit=2000' | jq ".results | .[] | select(.name==\"$1\") | .url" -r)" | jq '.height') decimeters" 'm;cm'
		pokeapi-mon "$1" | jq '.height' | xargs -I {} units -v1 '{}*0.1 m' 'ft;in'
		pokeapi-mon "$1" | jq '.height' | xargs -I {} units -v1 '{}*0.1 m' 'm;cm'
	}

	pokeapi-art() {
		pokeapi pokemon/$1 \
			| jq '
				.sprites | .other | .["official-artwork"][] | strings
				' -r \
			| wl-copy -n
	}

	pokeapi-mon() {
		pokeapi 'pokemon?limit=2000' \
			| jq ".results | .[] | select(.name==\"$1\") | .url" -r \
			| xargs -I URL pokeapi URL
	}

	pokeapi-species() {
		pokeapi 'pokemon?limit=2000' \
			| jq ".results | .[] | select(.name==\"$1\") | .url" -r \
			| xargs -I URL pokeapi URL
	}
}


##########################################
### quickly create scripts by language ###
##########################################

create-exe() {
	touch $1
	chmod u+x $1
}

create-sh() {
	echo '#!/bin/bash' > $1.sh
	chmod u+x $1.sh
}

create-zsh() {
	echo '#!/bin/zsh' > $1.zsh
	chmod u+x $1.zsh
}

create-py() {
	echo '#!/usr/bin/env python3' > $1.py
	chmod u+x $1.py
}

create-cpp() {
	filename=$1
	[[ -z $filename ]] && filename="main"
	echo "#include <iostream>\n\nusing namespace std;\n\nint main() {\n\treturn 0;\n}" > $filename.cpp
}

#######################################
### functions that could be scripts ###
#######################################

########################
### END OF FUNCTIONS ###
########################
