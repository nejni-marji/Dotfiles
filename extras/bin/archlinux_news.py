#!/usr/bin/env python3
from sys import argv
from urllib.request import urlopen
import xml.etree.ElementTree as ET

RSS_FEED = 'https://archlinux.org/feeds/news/'

webpage = urlopen(RSS_FEED)
xml_root = ET.parse(webpage).getroot()

manuals = [
		i
		for i in xml_root.iter()
		if i.tag=='item'
		and 'manual intervention' in i.find('title').text.lower()
		]

manuals = []
for i in xml_root.iter():
	if not i.tag == 'item':
		continue
	if not 'all' in argv[1:]:
		if not 'manual intervention' in i.find('title').text.lower():
			continue
	manuals.append(i)

# show most recent entries last
manuals.reverse()

for i in manuals:
	for j in ['title', 'pubDate', 'link']:
		print(i.find(j).text)
	print()
