#!/usr/bin/env python3
from i3ipc import Connection

import glob, os
socket = glob.glob('/run/user/%i/sway-ipc*' % os.getuid())[0]
i3 = Connection(socket_path = socket)

def resize(i3, event, args):
	parent = i3.get_tree().find_focused().parent

	print(args)
	mode = args[0]
	if not mode in ['grow', 'shrink']:
		print(1)
		return None

	while not (
		parent.layout == 'output'
		or
		(
			not len(parent.nodes) == 1
			and
			parent.layout in ['splith', 'splitv']
		)
	):
		parent = parent.parent

	if parent.parent.layout == 'output':
		return None

	direction = {
		'splith': 'width',
		'splitv': 'height',
	}[parent.layout]
	if (len(args) >= 2 and args[1] == 'rev'):
		direction = {
			'splith': 'height',
			'splitv': 'width',
		}[parent.layout]

	command = 'resize {} {} 10 px or 10 ppt'.format(mode, direction)
	i3.command(command)

def flatten(i3, event, args):
	target = i3.get_tree().find_focused()
	parent = target.parent

	if not parent.nodes == [target]:
		return None

	if any([i.type=='workspace' for i in [target, parent]]):
		return None

#	if parent.parent.type == 'workspace' and target.orientation == 'none':
#		return None

	if False: # rewrite: 2019-08-14 22:00:15
		i3.command('[con_id="%s"] mark --add _flat_target' % target.id)
		i3.command('[con_id="%s"] mark --add _flat_parent' % parent.id)

		i3.command('workspace tmp')
		i3.command('open')
		i3.command('mark --add _flat_tmpcon')

		i3.command('[con_mark="^_flat_parent$"] swap container with mark _flat_tmpcon')
		i3.command('[con_mark="^_flat_target$"] swap container with mark _flat_tmpcon')
		i3.command('[con_mark="^_flat_target$"] focus')
		i3.command('[con_mark="^_flat_tmpcon$"] kill')

		i3.command('unmark _flat_target')
		# i3.command('workspace back_and_forth')
		# i3.command('[con_mark="^_flat_target$"] focus')
		i3.command('[con_mark="^_flat_tmpcon$"] kill')

		i3.command('unmark _flat_target')

	i3.command(', '.join([
		('[con_id="%s"] mark --add "_flat_target"' % target.id),
		('[con_id="%s"] mark --add "_flat_parent"' % parent.id),
		'workspace back_and_forth',
		'workspace "tmp"',
		'append_layout ~/Dotfiles/extras/i3wm/flatten.json',
		'workspace back_and_forth',
		'[con_mark="^_flat_target$"] focus',
	]))

	i3.command(', '.join([
		'[con_mark="^_flat_parent$"] swap container with mark "_flat_tmpcon"',
		'[con_mark="^_flat_target$"] swap container with mark "_flat_tmpcon"',
		'[con_mark="^_flat_tmpcon$"] kill',
		'[con_mark="^_flat_target$"] focus',
		'unmark "_flat_target"',
	]))

# In order to focus only visible containers, I use the `cursor' variable to
# model a changing focus. This way, I don't have to actually touch the tree
# until the very end, when I can know exactly what I want to focus. This
# variable should always be global.

def get_cursor_state(direction):
	global cursor
	# helper variables
	cur = cursor
	par = cur.parent
	nod = par.nodes
	pnl = len(nod)

	# if the focus and the workspace are the same, stop
	if cur == cur.workspace():
		return 'workspace'

	# check if parent has a bad layout
	good_par_layout = {
		'left':  'splith',
		'down':  'splitv',
		'up':    'splitv',
		'right': 'splith',
	}[direction]

	if not par.layout == good_par_layout:
		return 'focus parent'

	# check if the cursor is at an endcap
	cur_pos = [
		i for
		i in range(pnl)
		if cur == nod[i]
	][0]

	bad_endcap = {
		'left':  0,
		'down':  pnl-1,
		'up':    0,
		'right': pnl-1,
	}[direction]

	if cur_pos == bad_endcap:
		return 'focus parent'

	# if the cursor is acceptable
	return 'okay'

# focus visible containers only (no inactive stacked or tabbed containers)
def focus_visible(i3, event, args):
	print(args)
	direction = args[0]
	if not direction in ['up', 'down', 'left', 'right']:
		return None

	# initialize the cursor
	global cursor
	cursor = i3.get_tree().find_focused()
	# original cursor position
	origin = cursor

	# determine what must be focused to focus a visible target direction
	while True:
		cur_state = get_cursor_state(direction)
		if cur_state == 'focus parent':
			cursor = cursor.parent
		else:
			break

	# if the cursor is the workspace, reset to the original container
	if cur_state == 'workspace':
		cursor = origin
		i3.command('[con_id="{}"] focus'.format(cursor.id))
		return None

	# only move if the cursor state is okay
	if get_cursor_state(direction) == 'okay':
		i3.command('[con_id="{}"] focus; focus {}'.format(
			cursor.id, direction
		))

def flipsplit(i3, event, args):
	print(args)

	target = i3.get_tree().find_focused()

	run_layout = True
	run_action = True

	if target.type == 'workspace':
		run_layout = False
	elif target.parent.type == 'workspace':
		if len(target.parent.nodes) == 1:
			run_layout = False

	print(f'layout: {run_layout}')
	print(f'action: {run_action}')



	def set_layout():
		layout = target.parent.layout

		layout_to_command = {
			'splith': 'split v',
			'splitv': 'split h',
			# 'stacked': 'split t; layout tabbed',
			# 'tabbed': 'split t; layout stacking',
			'stacked': 'split h',
			'tabbed': 'split v',
		}

		if not layout in layout_to_command:
			return [1, f'invalid layout: {layout}']

		# print(layout_to_command[layout])
		i3.command(layout_to_command[layout])

	def run_args():
		if args:
			i3.command(' '.join(args))

	if run_layout:
		set_layout()
	if run_action:
		run_args()

	# if target.type == 'workspace':
	# 	run_args()
	# elif target.parent.type == 'workspace' and len(target.parent.nodes) == 1:
	# 	run_args()
	# else:
	# 	set_layout()
	# 	run_arg()

	return [0, 'success']

def on_bind(i3, event):
	args = event.binding.command

	if not args.startswith('nop ipc'):
		return None
	args = args.split()

	commands = {
		'resize': resize,
		'flatten': flatten,
		'focvis': focus_visible,
		'flipsplit': flipsplit,
	}
	try:
		data = commands[args[2]](i3, event, args[3:])
		# print(data)
	except:
		pass

i3.on('binding', on_bind)

i3.main()
