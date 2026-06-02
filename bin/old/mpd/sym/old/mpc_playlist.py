#!/usr/bin/env python3
from subprocess import check_output
from multiprocessing import Process
from os import system
from time import sleep

# Forked library
from lib.textwrap import wrap as _wrap

# This is how many tracks to show above the current track.
# This will be 1 in the final build, but I want
# to be able to support an arbitrary value.
PRE_LEN=2
PRE_LEN=1



# Short functions

def check_output_s(command, timeout=None, **kwargs):
	return check_output(
		command.split(), timeout=timeout, **kwargs
	)

def check_output_d(command, timeout=None, **kwargs):
	return check_output(
		command, timeout=timeout, **kwargs
	).decode('utf-8')

def check_output_sd(command, timeout=None, **kwargs):
	return check_output(
		command.split(), timeout=timeout, **kwargs
	).decode('utf-8')

def check_output_a(flags, command, timeout=None, **kwargs):
	flags = list(flags)
	if 's' in flags:
		command = command.split()
	output = check_output(
		command, timeout=timeout, **kwargs
	)
	if 'd' in flags:
		output = output.decode('utf-8')
		if 'n' in flags:
			output = output.split('\n')
	if 't' in flags:
		output = output[:-1]
	return output

def wrap(width, text):
	return _wrap(
		text,
		width = width,
		subsequent_indent='\t',
		subsequent_indent_len=8
	)

def get_wh():
#	return (96, 8)
#	return (80, 20)
	return (
		int(check_output_sd('tput cols')[:-1]),
		int(check_output_sd('tput lines')[:-1]),
	)

def idle():
	data = check_output(
		'mpc idle'.split()
	).decode('utf-8')[:-1]
	return data



# MPD must be running
status = check_output_sd('mpc status')
assert len(status.split('\n')) >= 3



#todo:
'''
you can determine in advance, before you wrap at all, what the final line that should be drawn is, so you can say if the screen is too small
you can then later test to make sure you have that line, using a listcomp
'''



# Main functions

def draw_screen():
	tw, th = get_wh()

	# Current
	#TODO
	line_C = check_output_a('sdt', 'mpc current -f %position%')
	line_C = int(line_C)
	# Next
	line_N = line_C+1
	# First
	line_F = line_C - PRE_LEN
	while line_F <= 0:
		line_F += 1

	mpc_cmd =  'mpc playlist -f'.split()
	mpc_cmd += ['%position%\t[[%artist% .... ]%title%]|%file%']

	# Add '' to 1-index it
	# todo: Restrict 'lines' here to only what we need,
	#       making all other references relative.
	lines = [''] + check_output_d(mpc_cmd).split('\n')
	to_wrap = []

	separator = '#'*tw
	to_wrap += lines[line_F:line_C]
	to_wrap += [separator]
	to_wrap += [lines[line_C]]
	to_wrap += [separator]

	# Height, minus to_wrap, minus one more for readline
	pst_buflen = th-1-len(to_wrap)

	to_wrap += lines[line_N:line_N+pst_buflen]

	# Use join twice for wrapped lists and the listcomp
	wrapped = '\n'.join([
		'\n'.join(
			wrap(tw, line)
		)
		for line in to_wrap
	])

	# Split, pull the first th-1 lines
	cropped = wrapped.split('\n')[:th-1]

	# Add newlines to correct the height
	cropped += (th - 1 - len(cropped)) * ['']

	# Rejoin the lines we want
	output = '\n'.join(cropped)

	# Return our final product
	return output

def refresh_screen(mode='all'):
	while True:
		try:
			screen = draw_screen()
			print(screen)
		except ValueError: #TODO
			ERR_DELAY=5
			print('could not draw screen, waiting %i seconds' % ERR_DELAY)
			sleep(ERR_DELAY)

		if mode == 'all':
			idle_proc = Process(target=idle)
			idle_proc.start()
			wh = get_wh()

			while True:
				do_break = False
				exitcode = system('bash -c \'read -s -t 1\'')
				# if exitcode in [2, 130, 256]:
				if exitcode == 256:
					# add try-except?
					idle_proc.terminate()
					exit()
				if exitcode == 0:
					do_break = True
				if wh != get_wh():
					do_break = True
				if do_break:
					idle_proc.terminate()
					do_break = False
					break
				if not idle_proc.is_alive():
					break
			# done


		#TODO
		elif mode == 'idle':
			print('Mode not implemented.')
			exit(1)

		#TODO
		elif mode == 'manual':
			print('Mode not implemented.')
			exit(1)



# Run main function

refresh_screen()
