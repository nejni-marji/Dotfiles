#!/bin/bash

case $1 in
	on)
		pactl load-module module-null-sink
		pactl set-card-profile alsa_card.pci-0000_00_1f.3 off
	;;
	off)
		pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:analog-stereo
		pactl unload-module module-null-sink
	;;
esac
