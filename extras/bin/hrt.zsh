#!/bin/zsh
~/bin/mytime.zsh 'today 12:00' 'july 27 2021 12:00' sec | xargs -I {} units {}s 'year;month;day' \
| perl -pe 's/\s*(\d+) (y)ear \+ (\d+) (m)onth \+ (\d+)(?:\.\d+)? (d)ay/\1 years, \3 months, \5 days/'
