#!/usr/bin/env python3
# vim: fdm=marker

# from sys import argv
# from sys import stderr
# import re
# from enum import Enum
# from enum import auto

from datetime import datetime
from datetime import timedelta
from subprocess import check_output

# from pprint import pprint as PP
from argparse import ArgumentParser
# from math import gcd

# TODO:
# fuzzy_hm and fuzzy_dt are implemented.
# but nothing for showing datetime (NOT diffs) is implemented whatsoever.



NOW = datetime.now
# def NOW(): return datetime.fromtimestamp(1583879844)
INIT = NOW()
def rton(x, n): return int((x + n/2) / n ) * n



# {{{ parse functions
def parse_coreutils(s):
	d = check_output([
		'date',
		'+%s',
		'--date',
		s
	])
	# d = d.decode().lstrip().rstrip()
	d = int(d)
	return datetime.fromtimestamp(d)

def parse_numeric(s):
	return datetime.strptime(re.sub(r'[^\d]', '', s), '%Y%m%d%H%M%S')
# }}}

# {{{ time diffs
def td_diff(until=False, since=False):
	if until or since:
		until = until if until else NOW()
		since = since if since else NOW()
		return until - since
	return None

def td_until(dt):
	return dt - NOW()

def td_since(dt):
	return NOW() - dt

# {{{ td_to_tdarr
def td_to_tdarr(td):
	# The way this algorithm works...
	# You want to modulo by the size of the thing you're subdividing, and then you
	# want to divide by the size of the subdivisions. td.seconds is already modulo
	# by the seconds in a day, so we skip that. Finally, the atomic unit doesn't
	# need to be divided, only the modulo taken.
	if td.days < 0:
		sign = -1
		td *= -1
	else:
		sign = 1
	return [
		sign,
		td.days,
		int(  td.seconds         / 3600 ),
		int( (td.seconds % 3600) / 60   ),
		int(  td.seconds % 60           ),
	]
# }}}
# }}}

# {{{ output format symbols
DT_FORMATS = {
	'unix':     '%s',                        # 1561206495
	'unix2':    '%s.%N',                     # 1561206495.493439522
	'iso':      '%4Y-%m-%d T %H:%M:%S',      # 2019-06-22 T 07:28:15
	'plain':    '%4Y-%m-%d %H:%M:%S',        # 2019-06-22 07:28:15
	'date':     '%Y-%m-%d',                  # 2019-06-22
	'time':     '%H:%M:%S',                  # 07:28:15
	'cal':      '%A, %B %-d, %Y',            # Saturday, June 22, 2019
	'caltime':  '%A, %B %-d, %Y, %H:%M:%S',  # Saturday, June 22, 2019, 07:28:15
	'c':        '%a, %b %-d, %Y',            # Sat, Jun 22, 2019
	'ct':       '%a, %b %-d, %Y, %H:%M:%S',  # Sat, Jun 22, 2019, 07:28:15
}
TD_FORMATS = [
	'obj',
	'sec',
	'num',
	'char',
	'word',
]
TD_ALIASES = {
	# 'l': 'list',
	'o': 'obj',
	's': 'sec',
	'n': 'num',
	'c': 'char',
	'w': 'word',
}
# }}}

# {{{ print_tdarr
def print_tdarr(tdarr, fmt):
	if fmt in TD_ALIASES:
		fmt = TD_ALIASES[fmt]

	sign = tdarr[0]
	dhms = tdarr[1:]
	# vars: Time, Names, String, Join

	if fmt == 'num':
		while dhms[0] == 0:
			dhms = dhms[1:]
		resp = ':'.join(['%02i' % i for i in dhms])

	elif fmt in ['char', 'word']:
		if fmt == 'char':
			n = list('dhms')
			s = '%i%s'
			j = ' '

		elif fmt == 'word':
			n = 'days hours minutes seconds'.split(' ')
			s = '%i %s'
			j = ', '

		resp = [
			s % (dhms[i], n[i])
			for i
			in range(4)
			if dhms[i]
		]
		resp = j.join(resp)

	if sign == -1:
		if fmt == 'num':
			resp = '-' + resp
		if fmt in ['char', 'word']:
			resp += ' ago'

	return resp
# }}}

# {{{ print_td
def print_td(td, fmt):
	if fmt in TD_ALIASES:
		fmt = TD_ALIASES[fmt]
	# if not fmt in TD_FORMATS:
	# 	print(argv[0].split('/')[-1] + ': invalid format', file=stderr)
	# 	exit(1)

	if fmt == 'obj':
		resp = str(td)

	elif fmt == 'sec':
		resp = str(int(td.total_seconds()))

	elif fmt in ['num', 'char', 'word']:
		resp = print_tdarr(td_to_tdarr(td), fmt)

	return resp
# }}}

# {{{ fuzzy times
# {{{ fuzzy_hm
def fuzzy_hm(h, m, n=15):
	# near_mins, near_hour
	nm = rton(m, n)
	nh = h
	if nm == 60:
		nh+= 1
		nm = 0
	if nh == 24:
		nh = 0
	return (nh, nm)
# }}}

# {{{ fuzzy_dt
def fuzzy_dt(dt, n=15):
	return dt.replace(dt.year, dt.month, dt.day,
		*hm_to_fuzzy(
			dt.hour,
			dt.minute,
			n=n,
		),
		0,
		0,
		tzinfo=None
	)
# }}}
# }}}


# {{{ main()
if __name__ == '__main__':
	# {{{ ArgumentParser and add_argument
	parser = ArgumentParser(
		# description='Perform various time related functions. Use -u/-s to
		# compute diffs, or pass a date as a positional argument to have it formatted. Use -f to round the minutes to multiples of a given integer. Use -m to #TODO'
	)

	# {{{ verbose
	# parser.add_argument('-v', '--verbose',
	# 	action='count',
	# 	default=0,
	# )
	# }}}
	# {{{ until, since
	parser.add_argument('-s', '--since',
		metavar='DATE',
		# help='compute diffs',
		type=str,
		default='',
	)
	parser.add_argument('-u', '--until',
		metavar='DATE',
		# help='compute diffs',
		type=str,
		default='',
	)
	# }}}
	# {{{ date_fmt, diff_fmt
	# parser.add_argument('-f',# '--date-fmt',
	# 	metavar='FORMAT',
	# 	dest='date_fmt',
	# 	action='store',
	# 	help='Format for date mode',
	# 	# choices=DT_FORMATS,
	# 	default='plain',
	# )
	parser.add_argument('-f', '--diff-fmt',
		metavar='FORMAT',
		dest='diff_fmt',
		action='store',
		# help='Format for diff mode',
		# choices=TD_FORMATS + list(TD_ALIASES.keys()),
		default='num',
	)
	# }}}
	# {{{ fuzzy
	# parser.add_argument('-i', '--fuzzy',
	# 	metavar='INTERVAL',
	# 	help='round times to nearest multiple',
	# 	action='store',
	# 	nargs='?',
	# 	type=int,
	# 	default=0,
	# 	const=15,
	# )
	# }}}
	# {{{ numeric
	# use numeric parser instead of coreutils parser
	parser.add_argument('-n', '--numeric',
		help='Use numeric input (YYYY-mm-dd HH:MM:SS)',
		action='store_true',
	)
	# }}}
	# {{{ dates
	# parser.add_argument('dates',
	# 	metavar='DATE',
	# 	# action='store',
	# 	nargs='*',
	# 	type=str,
	# )
	# }}}
	# }}}

	args = parser.parse_args()
	parse_dt = parse_numeric if args.numeric else parse_coreutils

	if args.diff_fmt == 'list':
		print(TD_FORMATS)
		# print('available formats: ' + ', '.join(TD_FORMATS))
		exit()

	# {{{ handle if until or since
	if args.until or args.since:
		fmt = args.diff_fmt
		until = parse_dt(args.until) if args.until else NOW()
		since = parse_dt(args.since) if args.since else NOW()
		diff = until - since
		print(print_td(diff, fmt))
	# }}}
# }}}
