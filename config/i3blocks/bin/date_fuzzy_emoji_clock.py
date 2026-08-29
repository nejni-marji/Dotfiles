#!/usr/bin/env python3
from datetime import datetime


### get datetime
now = datetime.now()
hours, minutes = now.hour, now.minute


### fuzzy time
# variable is short because there used to be a long form
fuzzy_time_short = datetime.fromtimestamp(int((int(now.strftime('%s'))+7*60)/(15*60))*(15*60)).strftime('~%H:%M')


### emoji clock
emoji=['🌌','🌌','🌌','🌌','🌌','🌇','🌇','🌇','🏙️','🏙️','🏙️','🏙️','🏙️','🌆','🌆','🌆','🌆','🌆','🌆','🌃','🌃','🌃','🌃','🌌']
emoji_hour = emoji[hours-1]


### date format
date_long = now.strftime('%A, %B %-d,')
date_short = now.strftime('%a, %b %-d,')


### final result
print(' '.join([
	date_long,
	fuzzy_time_short,
	emoji_hour,
	'  ',
	]))
print(' '.join([
	date_short,
	fuzzy_time_short,
	emoji_hour,
	'  ',
	]))
