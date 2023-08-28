#!/usr/bin/env python3
from sys import argv

# I used to just use one of these, but when I added implementation for
# DIGIT+ZWJ+KEYCAP, I had to stop doing that, because I'm too lazy to actually
# implement that right now.

# print('  '.join([''.join([(chr(ord(c) + 127365) if c.lower() in 'abcdefghijklmnopqrstuvwxyz' else c) + ' ' for c in w]) for w in ' '.join(argv[1:]).split(' ')]))
# print('\n'.join([''.join([(chr(ord(c) + 127365) if c.lower() in 'abcdefghijklmnopqrstuvwxyz' else c) + ' ' for c in w]) for w in ' '.join(argv[1:]).split(' ')]))



ABC='abcdefghijklmnopqrstuvwxyz'
NUM='0123456789'
ZWJ='\uFE0F'
KEYCAP='\u20E3'
RI_STR = ':regional_indicator_%c:'    # discord emoji string
RI_OFFSET = 127365    # ord('🇦')-ord('a')



def get_ri_char(c):
	if not c.lower() in ABC:
		if c in NUM:
			return c + ZWJ + KEYCAP
		return c
	else:
		return chr(ord(c) + RI_OFFSET)
		# return (RI_STR % c if c.lower() in ABC else c)

def get_ri_str(args):
	s = '  '.join([
		''.join([
			get_ri_char(c) + ' '
			for c in w
		])
		for w in args
	])
	return s

def get_ri_str_listcomp(args):
	s = '  '.join([
		''.join([
			(chr(ord(c) + RI_OFFSET) if not c.lower() in ABC else c)
			for c in w
		])
		for w in args
	])
	return s

if __name__ == '__main__':
	print(get_ri_str(' '.join(argv[1:]).split(' ')))
