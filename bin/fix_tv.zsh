#!/bin/zsh
# vim: ts=8 nolist

just_pc() {
	# Set main display to 1080p with no pan
	xrandr --output HDMI-A-0 --primary --mode 1920x1080 --transform none --panning 0x0+0+0
	# Set alt display off
	xrandr --output HDMI-A-1 --off
	# Set hdmi card to pc output
	pactl set-card-profile alsa_card.pci-0000_01_00.1 output:hdmi-stereo-extra2
}

pc_and_tv() {
	() {
	# Set main display to 1080p with no pan
	xrandr --output HDMI-A-0 --primary --mode 1920x1080 --transform none --panning 0x0+0+0
	# Set alt display to custom calculated values just for my particular tv
	xrandr \
		--output HDMI-A-1 \
		--noprimary \
		--mode 1280x720 \
		--same-as HDMI-A-0 \
		--panning 1920x1080 \
		--transform ${(j:,:)@}
	} \
		1.5825	0	-52	\
		0	1.5825	-28	\
		0	0	1	\
	;
	# Do not set hdmi card at all, due to mixed modes it is unclear what
	# would be desired.
	#pactl set-card-profile alsa_card.pci-0000_01_00.1 output:hdmi-stereo-extra3
}

just_tv() {
	() {
	# Set main display off
	xrandr --output HDMI-A-0 --off
	# Set alt display to custom calculated values just for my particular tv
	xrandr \
		--output HDMI-A-1 \
		--primary \
		--mode 1280x720 \
		--panning 1280x720 \
		--transform ${(j:,:)@}
	} \
		1.055	0	-35	\
		0	1.055	-19	\
		0	0	1	\
	;
	# Set hdmi card to tv output
	pactl set-card-profile alsa_card.pci-0000_01_00.1 output:hdmi-stereo-extra3
}



case $1 in
	pc)
		just_pc
		;;
	both)
		pc_and_tv
		;;
	tv)
		just_tv
		;;
	*)
		echo "$0 [pc|both|tv]"
		;;
esac
