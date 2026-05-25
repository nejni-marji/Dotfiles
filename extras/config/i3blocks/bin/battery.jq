#!/usr/bin/jq -f

{
	"hours": "h",
	"minutes": "m",
	"seconds": "s",
	"days": "d",
} as $hms |

# assume that this array is a byproduct of jc
.[0].detail |

if .state == "discharging" then
	["ffff00", .percentage, .time_to_empty, .time_to_empty_unit]
elif .state == "charging" then
	["00ff00", .percentage, .time_to_full, .time_to_full_unit]
elif .state == "fully-charged" then
	["808080", .percentage]
elif .state == "pending-charge" then
	["ff0000", .percentage]
else
	["ff0000", .percentage]
end |

# print long and short
"<span foreground=\"#\(.[0])\">\(.[1] | floor)%\(
	# add comma if printing time
	if .[2] then "," else "" end
	)\(
	# print time only if nonempty
	if .[2]
	then " \(
		# round minutes/seconds
		if .[3] == "hours"
		then .[2]
		else .[2] | floor
		end
	)\($hms[.[3]])</span>"
	else ""
	end
)
<span foreground=\"#\(.[0])\">\(.[1] | floor)%</span>"
