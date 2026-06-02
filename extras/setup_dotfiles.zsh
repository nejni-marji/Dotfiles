#!/bin/zsh

cd ~
if ! [[ -d Dotfiles ]] ; then
	echo 'no such directory: Dotfiles'
	exit 10
fi

cd Dotfiles
for i in * ; do
	case $i in
		extras|bin|config)
			continue
			;;
		*)
			ln -srfnv $i ~/.$i
			;;
	esac
done

cd ~/Dotfiles
ln -srfnv bin ~/bin

cd ~/Dotfiles/config
mkdir -v ~/.config
for i in * ; do
	ln -srfnv $i ~/.config/$i
done

cd ~/Dotfiles/config
mkdir -pv nvim/data/backup/$HOST
mkdir -pv nvim/data/swap/$HOST
mkdir -pv nvim/data/undo/$HOST

cd ~/Dotfiles
host_suffixed=(
	# remember to update the .gitignore in tandem with this
	config/foot/foot.ini
	config/i3blocks/bin/date_fuzzy_emoji_clock.py
	config/i3blocks/config
	config/mako/config
	config/sway/config.d/host-include
)

cd ~/Dotfiles
for i in $host_suffixed ; do
	[[ -f $i-$HOST ]] &&
	ln -srv $i-$HOST $i
done

cd ~/Dotfiles
git submodule update --init
