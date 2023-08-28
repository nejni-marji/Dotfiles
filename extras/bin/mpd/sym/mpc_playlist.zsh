#!/bin/zsh

[[ -n $1 ]] && MPC_FORMAT=$1
local -a playlist=("${(f)$(mpc playlist | nl -n rn -w 1 -s '  ' )}")
local -i curr="$(mpc status | grep -Po '((?<=\[playing\] )|(?<=\[paused\]  ))#(\d+)/(\d+)' | grep -Po '(?<=#)\d+(?=/\d+$)')"
{
echo ${(F)playlist[1,$curr-1]/#/  }
# printf '\e[1m'
echo "> ${(F)playlist[$curr]}"
# printf '\e[0m'
echo ${(F)playlist[$curr+1,-1]/#/  }
} | fold -sw $COLUMNS
