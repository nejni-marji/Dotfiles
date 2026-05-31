#!/bin/bash

player="$(playerctl -l | head -n1)"

album="$(playerctl -p "$player" metadata --format '{{album}}')"
artist="$(playerctl -p "$player" metadata --format '{{artist}}')"
title="$(playerctl -p "$player" metadata --format '{{title}}')"

notify-send "${title}" "${album}${album:+${artist:+ by }}${artist}"
