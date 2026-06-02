#!/bin/zsh

# so here's my plan for how to structure this program:
>/dev/null <<EOM
case host in
	set vars

for each of $@, case in
	<host dependent list>)
		# +main|+aux|+laptop|+m|+a|+l|-main|-aux|-laptop|-m|-a|-l|+bt|+b|-bt|-b|+hdmi|+h|-hdmi|-h|main|aux|laptop|m|a|l|bt|b|hdmi|h)
		case in host
			a)
				case in ...
			b)
				case in ...
		esac
	*)
		case in
EOM

btr() {
	local bt_dev_name='Jam Transit Touch Headphones'
	local bt_dev=$(bluetoothctl devices | grep $bt_dev_name | grep -Po '[0-9a-fA-F:]{17}')
	case $HOST in
		turtwig)
			local bt_ssh=bronzong
			;;
		bronzong)
			local bt_ssh=turtwig
			;;
		*)
			exit 1
			;;
	esac

	case $1 in
		'true'|'local')
			ssh-add -t 1m
			ssh $bt_ssh bluetoothctl disconnect $bt_dev
			bluetoothctl connect $bt_dev
			;;
		'false'|'remote')
			ssh-add -t 1m
			bluetoothctl disconnect $bt_dev
			ssh $bt_ssh bluetoothctl connect $bt_dev
			;;
		*)
			ssh-add -t 1m
			ssh $bt_ssh bluetoothctl disconnect $bt_dev
			bluetoothctl connect $bt_dev
	esac
}

case $HOST in
	bronzong)
		local aux='alsa_card.pci-0000_00_1b.0'
		local hdmi='alsa_card.pci-0000_00_03.0'
		local bt_headset='bluez_card.0C_A6_94_F7_A3_4F'
		;;
	turtwig)
		local hdmi='alsa_card.pci-0000_01_00.1'
		local aux='alsa_card.pci-0000_00_1f.3'
		local bt_headset='bluez_card.0C_A6_94_F7_A3_4F'
		local capture_card='alsa_input.usb-MACROSILICON_MiraBox_Capture-02.analog-stereo'
		;;
esac

# iterate over $1 (we use `shift' before esac)
while ! [[ -z $1 ]] ; do
	echo "[$1]"
	# case $1 in
	# host-dependent args may be signed and must be lowercase
	if [[ "$1" =~ '^[+-]?[a-z]+$' ]] ; then

		case $HOST in
			bronzong)
				case $1 in
					# main mode
					+main|+aux|+laptop|+m|+a|+l)
						pactl set-card-profile $aux output:analog-stereo+input:analog-stereo
						;;
					-main|-aux|-laptop|-m|-a|-l)
						pactl set-card-profile $aux input:analog-stereo
						;;
					# bluetooth mode
					+bt|+b)
						until pactl set-card-profile $bt_headset a2dp_sink ; do
							sleep 1
						done
						# $0 KEY
						;;
					-bt|-b)
						pactl set-card-profile $bt_headset off
						;;
					# hdmi mode
					+hdmi|+h)
						pactl set-card-profile $hdmi output:hdmi-stereo
						;;
					-hdmi|-h)
						pactl set-card-profile $hdmi off
						;;
					# streaming modes
					+stream|+s)
						pactl load-module module-null-sink \
							sink_name=STREAM \
							sink_properties='device.description="Streaming\ Sink"' \
							;
						pactl load-module module-loopback \
							source=STREAM.monitor \
							;
							# do not set sink manually, it will probably
							# autodetect the correct device anyway
							#sink=alsa_output.usb-GuangZhou_FiiO_Electronics_Technology_Co.__Ltd._FiiO_M3K_FiiO_M3K-00.analog-stereo \
						;;
					-stream|-s)
						echo "Unloading module-null-sink..."
						pactl unload-module module-null-sink
						echo "Unloading module-loopback..."
						pactl unload-module module-loopback
						echo "Done."
						;;
					# meta modes
					main|aux|laptop|m|a|l)
						$0 +main -bt -hdmi
						;;
					bt|b)
						$0 +bt -main -hdmi
						;;
					hdmi|h)
						$0 +hdmi -main -bt
						;;
				esac # end case under bronzong
				;;
			turtwig)
				case $1 in
					# main mode
					+main|+hdmi|+m|+h)
						pactl set-card-profile $hdmi output:hdmi-stereo-extra2
						;;
					-main|-hdmi|-m|-h)
						pactl set-card-profile $hdmi off
						;;
					# bluetooth mode
					+bt|+b)
						until pactl set-card-profile $bt_headset a2dp_sink ; do
							sleep 1
						done
						# $0 KEY
						;;
					-bt|-b)
						pactl set-card-profile $bt_headset off
						;;
					# aux mode
					+aux|+a)
						pactl set-card-profile $aux output:analog-stereo
						;;
					-aux|-a)
						pactl set-card-profile $aux off
						;;
					+auxin|+ai)
						pactl set-card-profile $aux input:analog-stereo
						pactl set-source-volume alsa_input.pci-0000_00_1f.3.analog-stereo 70%
						;;
					-auxin|-ai)
						pactl set-card-profile $aux off
						;;
					+auxdx|+ad)
						pactl set-card-profile $aux output:analog-stereo+input:analog-stereo
						pactl set-source-volume alsa_input.pci-0000_00_1f.3.analog-stereo 70%
						;;
					-auxdx|-ad)
						pactl set-card-profile $aux off
						;;
					# tv mode
					 +tv)
					 	pactl set-card-profile $hdmi alsa_card.pci-0000_01_00.1 output:hdmi-stereo-extra3
					 	;;
					# -tv)
					# 	;;
					# streaming modes
					+stream|+s)
						pactl load-module module-null-sink \
							sink_name=STREAM \
							sink_properties='device.description="Streaming\ Sink"' \
							;
						pactl load-module module-loopback \
							source=STREAM.monitor \
							;
							# do not set sink manually, it will probably
							# autodetect the correct device anyway
							#sink=alsa_output.usb-GuangZhou_FiiO_Electronics_Technology_Co.__Ltd._FiiO_M3K_FiiO_M3K-00.analog-stereo \
						;;
					-stream|-s)
						echo "Unloading module-null-sink..."
						pactl unload-module module-null-sink
						echo "Unloading module-loopback..."
						pactl unload-module module-loopback
						echo "Done."
						;;
					# meta modes
					main|hdmi|m|h)
						$0 +main -bt -aux
						;;
					bt|b)
						$0 +bt -main -aux
						;;
					aux|a)
						$0 +aux -main -bt
						;;
					auxin|ai)
						$0 +auxin -main -bt
						;;
					auxdx|ad)
						$0 +auxdx -main -bt
						;;
					tv)
						;;
					# extra modes
					# +captbt|+cb)
					# 	pactl load-module module-loopback \
					# 		source=$capture_card \
					# 		sink=$bt_headset
					# 	;;
					# +capthdmi|+ch)
					# 	pactl load-module module-loopback \
					# 		source=$capture_card \
					# 		sink=$hdmi
					# 	;;
					# -capt|-c)
					# 	pactl unload-module module-loopback
					# 	;;
				esac
				;; # end case under turtwig
			esac # end 'case $HOST in'
	else # host independent args go here
		case $1 in
			Kmpd)
				# run xmodmap to fix keys for headset
				xmodmap -pk \
					| grep XF86AudioPause \
					&& xmodmap -e 'keysym XF86AudioPause = XF86AudioPlay'
				;;
			Kmpv)
				# run xmodmap to BREAK keys for headset
				xmodmap -pk \
					| grep XF86AudioPlay \
					&& xmodmap -e 'keysym XF86AudioPlay = XF86AudioPause'
				;;
		esac
	fi

	shift
done

