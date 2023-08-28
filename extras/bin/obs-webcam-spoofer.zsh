#!/bin/zsh
# vim: fdm=indent

spoof_on() {
	set -x

	# sudo modprobe v4l2loopback exclusive_caps=1 video_nr=9
	sudo modprobe v4l2loopback devices=1 video_nr=9 card_label="OBS Cam" exclusive_caps=1

	pactl load-module module-null-sink \
		sink_name=OBS \
		sink_properties='device.description="OBS\ Webcam"' \
		;
	pactl load-module module-virtual-source \
		source_name=FakeMic \
		master=OBS.monitor \
		;

	set +x
}

spoof_off() {
	set -x

	sudo rmmod v4l2loopback
	pactl unload-module module-loopback
	pactl unload-module module-virtual-source
	pactl unload-module module-null-sink

	set +x
}

stream_fiio() {
	set -x

	pactl load-module module-null-sink \
		sink_name=STREAM \
		sink_properties='device.description="Streaming\ Sink"' \
		;
	pactl load-module module-loopback \
		source=STREAM.monitor \
		sink=alsa_output.usb-GuangZhou_FiiO_Electronics_Technology_Co.__Ltd._FiiO_M3K_FiiO_M3K-00.analog-stereo \
		;

	set +x
}

stream_aux() {
	set -x

	pactl load-module module-null-sink \
		sink_name=STREAM \
		sink_properties='device.description="Streaming\ Sink"' \
		;
	pactl load-module module-loopback \
		source=STREAM.monitor \
		sink=alsa_output.pci-0000_00_1f.3.analog-stereo \
		;

	set +x
}


# if [[ $1 == start ]] ; then
# 	spoof_on
# elif
# 	[[ $1 == stop ]] ; then
# 	spoof_off
# else
# 	echo "$0 [start|stop]"
# 	exit 10
# fi


case $1 in
	start)
		spoof_on
		;;
	stop)
		spoof_off
		;;
	aux)
		stream_aux
		;;
	*)
		echo "$0 [start|stop]"
		exit 10
		;;
esac
