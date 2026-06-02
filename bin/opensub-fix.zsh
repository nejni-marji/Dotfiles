#!/bin/zsh

data=~/Dotfiles/extras/misc/opensubtitles_data.txt

for i in *.srt ; do
	if ! [[ -f .$i ]] ; then
		if [[ $1 == demo ]] ; then
			< $i | grep -Fif $data
			echo
		else
			echo "fixed: $i"
			< $i | grep -Fivf $data > tmp
			mv $i .$i ; mv tmp $i
		fi
	elif [[ $1 != demo ]] ; then
		echo "ignore: $i"

	fi
done

