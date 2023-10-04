#!/bin/zsh

data=~/Dotfiles/extras/opensubtitles_data.txt

for i in *.srt ; do
	if ! [[ -f .$i ]] ; then
		< $i | grep -Fivf $data > tmp
		mv -v $i .$i ; mv tmp $i
	fi
done

