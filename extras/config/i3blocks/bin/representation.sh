while swaymsg -t get_workspaces |
	jq -cr '..
	| select(.focused? and .type=="workspace").representation
	#| . as $full
	| if .==null then
	"•" else
		gsub("(?<=\\[| )[\\w_-]+(?!\\[) ?"; "•")
		| gsub("(?<a>•{4,})"; "\(.a | length)")
		| gsub("•(?<a>[HVTS])"; "• \(.a)")
	end
	#| . as $short
	#| {"full_text": $full, "short_text": $short}
	'
	true
do swaymsg -t subscribe \
	'["window", "workspace", "output", "binding"]' \
	>/dev/null 2>&1
	# sleep for half a 60Hz refresh, should be enough
	sleep 0.008
done
