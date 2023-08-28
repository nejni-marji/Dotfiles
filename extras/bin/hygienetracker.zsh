#!/bin/zsh

if [[ ( $1 == set ) || ( $1 == put ) ]] ; then
	dest=~/Documents/hygiene/tracker/$2.txt
	date '+%F %T' >> $dest
fi

