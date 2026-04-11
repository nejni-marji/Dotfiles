#!/bin/bash
# 5Ws are empty
[[ -z "$(cal $1 | cut -zc 53,137 | tr -d '0-9\0')" ]]
exit $?
