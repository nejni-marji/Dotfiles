#!/bin/bash
# 5Ws are empty
[[ -z "$(cal -d $1 | cut -zc 57,149 | tr -d '0-9\0')" ]]
exit $?
