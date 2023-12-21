#!/bin/zsh

# Script for learning about what packages are installed on my system.
#
# It currently only has one real mode, but I've done lots of "pacstudy" before,
# so I imagine that it might need extended at some point.

ignore_bronzong=( dvdbackup handbrake-cli jdk-openjdk k3b libdvdcss php vulkan-radeon )
ignore_turtwig=( )


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

pacstudy_run() {
	ssh_host=$1
	pacflags=$2

	ignore="ignore_${HOST}"
	ignore=${(P)ignore}
	re_parse='s/Name\s*: (.*)\nDescription\s*: (.*)\n/\e[0;1m\1\e[0m \e[1;32m\2\e[0m\n/g'
	#re_ignore='\e\[0
	cmd="pacman $pacflags |
		grep -P '^(Name|Description)' |
		perl -0 -pe '$re_parse' |
		grep -Pv"
	eval $cmd
	# data_local=( 
	# comm --nocheck-order <(eval $cmd) <(ssh $ssh_host $cmd) -3
}



# PRINT HEADER
echo -n '\e[1m'
comm --nocheck-order <(echo $HOST) <(echo $ssh_host)
echo -n '\e[0m'
echo

pacstudy_get_ssh_host
pacstudy_run $ssh_host -Qein


# echo
# cmd="pacman -Qeim | grep -P '^(Name|Description)' | perl -0 -pe 's/Name\s*: (.*)\nDescription\s*: (.*)\n/\e[0;1m\1\e[0m \e[1;32m\2\e[0m\n/g'"
# comm --nocheck-order <(eval $cmd) <(ssh $ssh_host $cmd) -3
