#!/bin/zsh

# Script for learning about what packages are installed on my system.
#
# It currently only has one real mode, but I've done lots of "pacstudy" before,
# so I imagine that it might need extended at some point.



pacstudy_compare() {
	pacflags=$1
	comm <(pacman $pacflags | sort) <(ssh $ssh_host pacman $pacflags | sort) -3
}

pacstudy_compare_no3() {
	pacflags=$1
	comm <(pacman $pacflags | sort) <(ssh $ssh_host pacman $pacflags | sort)
}

pacstudy_get_ssh_host() {
	if [[ -z $ssh_host ]] ; then
		case $HOST in
			bronzong)
				ssh_host=turtwig
				;;
			turtwig)
				ssh_host=bronzong
				;;
		esac
	fi
}


case $1 in
	versions)
		pacstudy_get_ssh_host
		pacstudy_compare -Qen
		echo
		pacstudy_compare -Qem
		;;
	orphans)
		pacstudy_get_ssh_host
		pacstudy_compare_no3 -Qqdt
		echo
		pacstudy_compare_no3 -Qqdtt
		;;
	alldeps)
		pacstudy_get_ssh_host
		pacstudy_compare -Qqn
		echo
		pacstudy_compare -Qqm
		;;
	# explicitdesc)
	# 	pacstudy_get_ssh_host
	# 	pacstudy_compare -Qei
	# 	;;
	old_compare)
		pacstudy_get_ssh_host
		pacstudy_compare -Qqen
		echo
		pacstudy_compare -Qqem
		;;
	*)
		pacstudy_get_ssh_host
		echo -n '\e[1m'
		comm --nocheck-order <(echo $HOST) <(echo $ssh_host)
		echo -n '\e[0m'
		echo
		cmd="pacman -Qein | grep -P '^(Name|Description)' | perl -0 -pe 's/Name\s*: (.*)\nDescription\s*: (.*)\n/\e[0;1m\1\e[0m \e[1;32m\2\e[0m\n/g'"
		comm --nocheck-order <(eval $cmd) <(ssh $ssh_host $cmd) -3
		echo
		cmd="pacman -Qeim | grep -P '^(Name|Description)' | perl -0 -pe 's/Name\s*: (.*)\nDescription\s*: (.*)\n/\e[0;1m\1\e[0m \e[1;32m\2\e[0m\n/g'"
		comm --nocheck-order <(eval $cmd) <(ssh $ssh_host $cmd) -3
		;;

esac
