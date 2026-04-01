while swaymsg -t get_workspaces |
	jq -c '..
	| select(.focused?).representation
	| gsub("(?<=\\[| )[\\w_-]+(?!\\[) ?"; "•")
	| gsub("(?<m>•{4,})"; "\(.m | length)")'
do swaymsg -t subscribe \
	'["window", "workspace", "output", "binding"]' \
done
