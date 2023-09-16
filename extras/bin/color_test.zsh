#!/bin/zsh

typeset -i fg bg

local -a nor_bg=({40..47})
local -a nor_fg=({30..37})

if [[ $1 == bright ]] ; then
	local -a nor_bg=({100..107})
	local -a nor_fg=({90..97})
fi

local -a alt_bg=( 41 42 44 46 45 43 40 47 )
local -a alt_fg=( 31 32 34 36 35 33 30 37 )

local -a use_bg=($nor_bg)
local -a use_fg=($nor_fg)

if [[ $1 == alt ]] ; then
	local -a use_bg=($alt_bg)
	local -a use_fg=($alt_fg)
fi


# First row, bg titles
echo -ne '\t\t'
for bg in $use_bg ; do
	echo -ne "  ${bg}m\t"
done

echo

# 2nd row, m
echo -ne "    m\t"
echo -ne "\e[0m  gYw  \t"
for bg in $use_bg ; do
	echo -ne "\e[${bg}m  gYw  \e[0m\t"
done

echo

# 3rd row, 1m
echo -ne "   1m\t"
echo -ne "\e[1m  gYw  \t"
for bg in $use_bg ; do
	echo -ne "\e[1;${bg}m  gYw  \e[0m\t"
done

echo

# main table
for fg in $use_fg ; do

	echo -ne "  ${fg}m\t"
	echo -ne "\e[${fg}m  gYw  \e[0m\t"
	for bg in $use_bg ; do
		echo -ne "\e[${fg};${bg}m  gYw  \e[0m\t"
	done
	echo

	echo -ne "1;${fg}m\t"
	echo -ne "\e[1;${fg}m  gYw  \e[0m\t"
	for bg in $use_bg ; do
		echo -ne "\e[1;${fg};${bg}m  gYw  \e[0m\t"
	done
	echo
done
