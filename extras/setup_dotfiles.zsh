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

cd extras
ln -srfnv bin ~/bin

cd config
mkdir -v ~/.config
for i in * ; do
	ln -srfnv $i ~/.config/$i
done

mkdir -pv nvim/data/backup/$HOST
mkdir -pv nvim/data/swap/$HOST
mkdir -pv nvim/data/undo/$HOST
