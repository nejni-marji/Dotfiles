#!/bin/zsh
# vim: fdm=indent

exec 3>&1
exec 4>>~/autoargs_log.txt
# exec 3>&2
# exec 3>/dev/null

show_help() {
cat <<-EOM
Usage: $0
-h, --help  show this message and exit
EOM
exit 0
}

# if [[ $1 =~ '^(-?h|(--)?help)$' ]] ; then
# 	show_help
# fi

date '+%F %T' >&3 >&4

echo 0: "${(qqq)0:t}" >&3 >&4

# # flag is x, option is x:
# OPTSTR='hvn:f:i:o:'
# # OPTSTR=':'
# while getopts "$OPTSTR" opt ; do
# 	echo "${opt}: ${(qqq)OPTARG}" >&3 >&4
# 	case $opt in
# 	esac
# done
local -a ARGS=(${@[$OPTIND,-1]})
for ((i=1 ; i<=${#ARGS} ; i+=1)) ; do
	echo "$i: ${(qqq)ARGS[$i]}" >&3 >&4
	done

read '?Hit enter to continue: '
