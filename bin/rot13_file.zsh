#!/bin/zsh
old="$1"
new="$( echo ${old:r} | tr 'A-Za-z' 'N-ZA-Mn-za-m' )_rot13.${old:e}"
echo "ln -s $old $new"
