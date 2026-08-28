#!/bin/bash

if makoctl mode | grep do-not-disturb ; then
	makoctl dismiss --all
	makoctl mode -r do-not-disturb
	pkill -SIGRTMIN+3 i3blocks
fi

makoctl restore
