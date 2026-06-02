#!/bin/bash

# update batsignal
pkill -SIGUSR1 batsignal

upower -i /org/freedesktop/UPower/devices/DisplayDevice |
	jc --upower |
	~/.config/i3blocks/bin/battery.jq -r
