#!/usr/bin/env python3
from sys import argv

sentence = ' '.join(argv[1:])

new_sentence = ''
isUpper = False
for c in sentence:
	if c.isalpha():
		if isUpper:
			new_sentence += c.upper()
		else:
			new_sentence += c.lower()
		isUpper = not isUpper
	else:
		new_sentence += c

print(new_sentence)
