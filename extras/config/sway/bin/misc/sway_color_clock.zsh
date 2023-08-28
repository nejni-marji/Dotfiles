#!/bin/zsh



# debug command
decho() {
	# echo "$@"
}



# set up basic values
curr_time='now'
if [[ $1 == 'debug_time' ]]; then
	curr_time="$2"
fi

if [[ $1 == 'debug_selftest' ]] ; then
	BAR() { eval 'printf '\''%0.s#'\'' {1..$COLUMNS} ; print' }
	# datewidth=$(date +'%a, %b %-d, %H:%M:%S')
	# termwidth=$(( $COLUMNS / $#datewidth ))
	# clear ; BAR
	# local -i c=1;
	# for ((h=0;h<23;h+=6)) ; do
	# for ((m=0;m<59;m+=10)) ; do
	# for ((s=0;s<59;s+=10)) ; do
	# H=${(l:2::0:)h} ; M=${(l:2::0:)m} ; S=${(l:2::0:)s}
	# $0 debug_time "$H:$M:$S" | tr '\n' ' '
	# ((C = c % termwidth ))
	# [[ $C == 0 ]] && echo
	# ((c++))
	# done ; done ; done ; echo ; BAR
	# BETTER IMPLEMENTATION
	reset ; clear ; BAR
	local -i c=1;
	for ((h=0;h<=24;h+=6)) ; do
	for ((m=0;m<=60;m+=10)) ; do
	for ((s=0;s<=60;s+=10)) ; do
	[[ $h == 24 ]] && h=23
	[[ $m == 60 ]] && m=59
	[[ $s == 60 ]] && s=59
	H=${(l:2::0:)h} ; M=${(l:2::0:)m} ; S=${(l:2::0:)s}
	#echo "$H:$M:$S" | tr '\n' ' '
	#date --date "$H:$M:$S" '+%a, %b %d, %T' | tr '\n' ' '
	color_clock.zsh debug_time "$H:$M:$S" | tr '\n' ' '
	((C = c%7 ))
	[[ "$H:$M:$S" == "23:59:59" ]] && break
	[[ $C == 0 ]] && echo
	((c++))
	done ; done ; done ; echo ; BAR ; read
fi

# store time
arr_hms=(${(s_:_)$(date --date "$curr_time" +%T)})



# store decimal values of each segment of the time
dec_h=$arr_hms[1]
dec_m=$arr_hms[2]
dec_s=$arr_hms[3]

# map each segment of time to RGB space
bg_r=$(( $dec_h * 255 / 23 ))
bg_g=$(( $dec_m * 255 / 59))
bg_b=$(( $dec_s * 255 / 59))



# unused method of generating foreground colors
# fg_r=$(( ($bg_r + 128) % 256 ))
# fg_g=$(( ($bg_g + 128) % 256 ))
# fg_b=$(( ($bg_b + 128) % 256 ))

# another unused method
# bg_lum_bc=$(echo "0.2126*(($bg_r/255)^2.2) + 0.7151*(($bg_g/255)^2.2) + 0.0721*(($bg_b/255)^2.2)" | bc -l 2>/dev/null)



# generate luminance values for background
typeset -F bg_lum="$(( 0.2126*( ($bg_r/255.)**2.2) + 0.7151*( ($bg_g/255.)**2.2) + 0.0721*( ($bg_b/255.)**2.2) ))"
# invert those values for the foreground
typeset -F fg_lum=$(( 1-$bg_lum ))
# multiply that by 255 and typecast to int to obtain black or white
# TODO: technically i am cheating by doing +0.4 instead +0.5 but whatever
typeset -i fg_all=$(( $fg_lum+0.5 ))
typeset -i fg_all=$(( $fg_lum+0.4 )) # TODO: adjust this value to adjust sensitivity
typeset -i fg_all=$(( $fg_all*255 ))



# set foreground to $fg_all
fg_r=$fg_all
fg_g=$fg_all
fg_b=$fg_all


hex_color="$(printf '#%02x%02x%02x' ${bg_r} ${bg_g} ${bg_b})"
swaymsg "output * bg $hex_color solid_color"



# # set $clock to be an ANSI escape code for the appropriate colors
# clock="\e[48;2;${bg_r};${bg_g};${bg_b};38;2;${fg_r};${fg_g};${fg_b}m"
# # set $clockend to the ANSI escape code for reset
# clockend="\e[0m"



# # actually print the date using those ANSI codes
# echo "${clock}$(date --date "$curr_time" +'%a, %b %-d, %H:%M:%S')${clockend}"
