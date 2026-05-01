#!/bin/bash

font="$(
	grep -h \
		~/.config/sway/config \
		~/.config/sway/config.d/host-include-$HOSTNAME \
		-Po -e '(?<=set \$font )[^#]+' |
		head -n1
)"

echo $font

window=$(swaymsg -t get_tree | jq -r '
.. |
	select((.type?=="con" or .type?=="floating_con") and (.nodes? | length==0)) |
	"#\(.id): \(.name) (\(
		if .app_id then "app_id" else "class" end
	): \(
		if .app_id then .app_id else .window_properties.class end
	))"
' |
wmenu -i -l 15 -f "$font" -p 'Windows:' \
	-M ff8cda -m 000000 -N 8cdaff -n 000000 -S ff8cda -s 000000 \
)

con_id=${window%%:*}
con_id=${con_id#\#}

echo $con_id

swaymsg "[con_id=$con_id] focus"
