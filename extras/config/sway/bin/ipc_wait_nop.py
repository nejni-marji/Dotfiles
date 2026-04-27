#!/usr/bin/env python3
from i3ipc import Connection
sway = Connection()



def on_binding(self, event):
	command = event.binding.command

	print(command)
	if command.startswith('nop ipc'):
		run_cmd(*command.split()[2:])

def run_cmd(*args):
	print(args)

	if args[0] == 'focus-or-create':
		if args[1] == 'volume':
			pass

if __name__ == '__main__':
	sway.on('binding', on_binding)
	sway.main()
