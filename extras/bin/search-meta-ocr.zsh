#!/bin/zsh

dir_tg=~/storage/shared/Pictures/Telegram
dir_scn=~/storage/shared/Pictures/Screenshots
dir_dl=~/storage/shared/Download
dir_manga=~/storage/shared/Pictures/Mihon
dir_all=( $dir_tg $dir_scn $dir_dl )

modes=( )
dirs=( )
args=( )

opt_old=false
opt_index=false

while [[ -n $@ ]] ; do
	case $1 in
		tg|telegram)
			modes+=telegram
			dirs+=$dir_tg
			;;
		screen|screenshot)
			modes+=screenshots
			dirs+=$dir_scn
			;;
		dl|download)
			modes+=downloads
			dirs+=$dir_dl
			;;
		manga)
			modes+=manga
			dirs+=$dir_manga
			;;
		all)
			mode+=all
			dirs=($dir_all)
			;;
		old)
			modes+=old
			opt_old=true
			;;
		index)
			modes+=index
			opt_index=true
			dirs=($dir_all)
			;;
		'--')
			shift
			args+=($@)
			break
			;;
		*)
			args+=$1
			;;
	esac
	shift
done

# make all dirs absolute
temp=( $dirs )
dirs=( )
for i in $temp ; do
	dirs+=(${i:A})
done
unset temp

# add old dirs if necessary
if $opt_old ; then
	for i in $dirs ; dirs+=$i.old
fi

typeset modes
typeset dirs
typeset args
echo

# exit


for i in $dirs ; do
	cd $i
	echo "${PWD:A}:\n"

	if $opt_index ; then
		echo 'indexing...'
		ocr-index
	else
		ocr-search $args
	fi
	echo

done


