#!/bin/zsh

cd ~
if ! [[ -d Dotfiles ]] ; then
	echo 'no such directory: Dotfiles'
	exit 10
fi

cd Dotfiles
for i in * ; do
	if [[ $i == extras ]] ; then
		continue
	fi
	ln -srfnv $i ~/.$i
done

cd ~/Dotfiles/extras
ln -srfnv bin ~/bin

cd ~/Dotfiles/extras/config
mkdir -v ~/.config
for i in * ; do
	ln -srfnv $i ~/.config/$i
done

cd ~/Dotfiles/extras/config
mkdir -pv nvim/data/backup/$HOST
mkdir -pv nvim/data/swap/$HOST
mkdir -pv nvim/data/undo/$HOST

cd ~/Dotfiles
host_suffixed=(
	extras/config/foot/foot.ini
	extras/config/i3blocks/bin/date_fuzzy_emoji_clock.py
	extras/config/i3blocks/bin/representation.sh
	extras/config/i3blocks/config
	extras/config/mako/config
	extras/config/sway/config
)

cd ~/Dotfiles
for i in $host_suffixed ; do
	[[ -f $i-$HOST ]] &&
	ln -srv $i-$HOST $i
done

cd ~/Dotfiles
git submodule update --init
