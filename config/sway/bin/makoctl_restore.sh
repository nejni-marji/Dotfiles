#!/bin/bash

# if dnd is set, dismiss all notifs and unset it. this is so that hitting restore will only visually add one notif at a time, even from dnd being enabled.
if makoctl mode | grep do-not-disturb ; then
	makoctl dismiss --all
	makoctl mode -r do-not-disturb
	pkill -SIGRTMIN+3 i3blocks
fi

makoctl restore
