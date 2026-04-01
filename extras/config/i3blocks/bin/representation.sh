while swaymsg -t get_workspaces |
	jq -cr '..
	| select(.focused? and .type=="workspace").representation
	| if .==null then
	"•" else
		gsub("(?<=\\[| )[\\w_-]+(?!\\[) ?"; "•")
		| gsub("(?<m>•{4,})"; "\(.m | length)")
	end'
	true
do swaymsg -t subscribe \
	'["window", "workspace", "output", "binding"]' \
	>/dev/null 2>&1
	# sleep for half a 60Hz refresh, should be enough
	sleep 0.008
done
