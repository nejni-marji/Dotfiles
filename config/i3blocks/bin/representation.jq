#!/usr/bin/jq -f

(.. |
	select(.type?=="workspace" and (.. | .focused?)))
	as $workspace |
([.. |
	select(.scratchpad_state? | . and .!="none")] | length)
	as $scratchpad_length |
(.. |
	select(.focused?).scratchpad_state != "none")
	as $scratchpad_focus |

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
# after ], dot,   before HVTS[
gsub("(?<=[]•>])(?<a>(<span foreground=\"#[0-9A-Fa-f]{6}\">)?[HTVS](</span>)?\\[)"; " \(.a)") |
# after ], before dot, HVTS[
gsub("(?<=])(?<a>(<span foreground=\"#[0-9A-Fa-f]{6}\">)?[HTVS•](</span>)?\\[?)"; " \(.a)") |
# i don't know why this works
gsub("(?<=[)(<span foreground=\"[0-9A-Fa-f]{6}\">) (?<a>[HVTS])"; "\(.a)") |

if $scratchpad_length==0 then . else "\(.) \(
	if $scratchpad_focus then "<span foreground=\"#ff8cda\">" else "" end
)+\($scratchpad_length)\(
	if $scratchpad_focus then "</span>" else "" end
)" end
