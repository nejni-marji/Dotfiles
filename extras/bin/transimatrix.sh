#!/bin/bash
for i in cyan magenta white magenta cyan ; do
	foot -T - \
		unimatrix.py -aif -s 80 -c $i &!
	sleep 0.1
done
