#!/bin/bash

# long
acpi -b |
perl -pe '
s/^Battery (\d+): ([^,]+), (\d+%)(?:, ([\d:]+?):\d\d )?.*/<span foreground="#\2">\3<\/span> (~\4)/;
s/Not charging/808080/;
s/Discharging/ff0000/;
s/Charging/00ff00/;
s/Full/808080/;
s/ \(~\)//;
s/\n/, /;
' |
perl -pe '
s/, ?$/\n/;
s#</span>, #,</span> #g;
'

# short
acpi -b |
perl -pe '
s/^Battery (\d+): ([^,]+), (\d+%)(?:, ([\d:]+?):\d\d )?.*/<span foreground="#\2">\3<\/span>/;
s/Not charging/808080/;
s/Discharging/ff0000/;
s/Charging/00ff00/;
s/Full/ffffff/;
s/ \(~\)//;
s/\n/, /;
' |
perl -pe '
s/, ?$/\n/;
s#</span>, #,</span> #g;
'
