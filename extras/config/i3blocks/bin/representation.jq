#!/usr/bin/jq -f

.. | select(.type?=="workspace" and (.. | .focused?)) as $workspace |

# prefixes for split types
{
	"splith": "H",
	"splitv": "V",
	"tabbed": "T",
	"stacked": "S",
} as $layouts |

def recurse:
	# base case has no splits
	if .layout=="none" then
		# get base case name
		if .app_id then
			.app_id
		elif .window_properties.class then
			.window_properties.class
		else
			"?"
		# store it to $k
		end as $k |

		# replace base case name with dot
		"•" as $k |

		# apply focus/urgent colors
		if .focused then
			"<span foreground=\"#ff8cda\">\($k)</span>"
		elif .urgent then
			"<span foreground=\"#ffc68c\">\($k)</span>"
		else
			$k
		end

	# complex case has splits
	else
		# store layout prefix as $k
		$layouts[.layout] as $k |

		# apply focus colors
		if .focused then
			"<span foreground=\"#ff8cda\">\($k)</span>"
		else
			$k
		# store as $prefix
		end as $prefix |

		"\($prefix)[\(
		# recursive function
		.nodes | map(recurse) | join("")
		)]"
	end
;

$workspace |
recurse |
# after ], dot, >,   before HVTS[
gsub("(?<=[]•>])(?<a>(<span foreground=\"#[0-9A-Fa-f]{6}\">)?[HTVS](</span>)?\\[)"; " \(.a)") |
# after ], before dot, <
gsub("(?<=])(?<a>•|<)"; " \(.a)") |



.
