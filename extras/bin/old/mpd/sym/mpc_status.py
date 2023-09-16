#!/usr/bin/env python3
from subprocess import check_output
CO = check_output

data = [i for i in check_output(['mpc', '-f', '', 'status']).decode().split('\n') if i]

def parse_l1(d1):
	is_playing = d1[0] == '[playing]'

	if is_playing:
		playstr = '\x1b[32m|>'
	else:
		# playstr = '\x1b[31m||'
		playstr = '\x1b[31m[]'

	timestr = '{}: {}, {}'.format(
		d1[1], d1[2], d1[3][1:-1]
	)
	return [playstr, timestr]

def parse_l2(d2):
	volstr=d2[1]

	optchars = list('ersc')
	optbool = [d2[3], d2[5], d2[7], d2[9]]
	optstr = ''.join([
		optchars[i] if optbool[i]=='off' else optchars[i].upper()
		for i in range(4)
	]) + ','

	return [optstr, volstr]
	return [volstr, optstr]

if len(data) == 2:
	d1 = [i for i in data[0].split(' ') if i]
	# this replacement fixes a small bug
	data[1] = data[1].replace('volume:100%', 'volume: 100%')
	d2 = [i for i in data[1].split(' ') if i]

	albumlen = len(
		CO([
			'mpc', 'find', 'album', CO([
				'mpc', '-f', '%album%', 'current'
			]).decode().rstrip()
		]).decode().rstrip().split('\n')
	)

	if albumlen == 0:
		albumdisp = ''
	else:
		albumdisp = f'/{albumlen}'

	formatstr = '\e\[1;34m[[%title%]|%file%]\e\[0m[\n\e\[1;36m%artist%\e\[0m[ (\e\[32m##%track%{}\e\[0m)\n\e\[36m%album%\e\[0m ]'.format(
		albumdisp
	)

	curstr = check_output(['mpc', '-f', formatstr, 'current']).decode().rstrip('\n')


	print('{}\n{} {}\n{} {}\x1b[0m'.format(
		curstr,
		*parse_l1(d1),
		*parse_l2(d2),
	))

elif len(data) == 1:
	d2 = [i for i in data[0].split(' ') if i]

	print('{} {}'.format(
		*parse_l2(d2),
	))
