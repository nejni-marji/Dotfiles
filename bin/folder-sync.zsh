#!/bin/zsh

# "~/directory" -> "directory"
here=${PWD#$HOME/}

if [[ $here[1] == '/' ]] ; then
	echo "not in home folder, quitting"
	exit 20
fi

case $HOST in
	turtwig)
		host=bronzong
		;;
	bronzong)
		host=turtwig
		;;
	*)
		echo "not a valid host, quitting"
		exit 21
		;;
esac

case $1 in
	get|pull|recv|recieve)
		rsync --dry-run -hav -RKk $host:$here ~/
		echo "\\\\rsync -hav -RKk $host:$here ~/"
		;;
	put|push|send)
		rsync --dry-run -hav -RKk ~/./$here $host:
		echo "\\\\rsync -hav -RKk ~/./$here $host:"
		;;
esac


