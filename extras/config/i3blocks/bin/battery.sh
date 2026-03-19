#!/bin/bash

acpi -b |
perl -pe '
s/^Battery (\d+): ([^,]+), (\d+%)(?:, ([\d:]+?):\d\d )?.*/<span foreground="#\2">\3<\/span> (~\4)/;
s/Not charging/808080/;
s/Discharging/ff0000/;
s/Charging/00ff00/;
s/Full/00ff00/;
s/ \(~\)//;' |
tr '\n' , |
perl -pe 's/,/, /g; s/, $/\n/'
