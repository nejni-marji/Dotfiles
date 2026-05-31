#!/bin/zsh

player="$(playerctl -l | head -n1)"

album="$(playerctl -p "$player" metadata --format '{{album}}')"
artist="$(playerctl -p "$player" metadata --format '{{artist}}')"
title="$(playerctl -p "$player" metadata --format '{{title}}')"
typeset -i volume=$((100*"$(playerctl -p "$player" volume)"))

typeset album
typeset artist
typeset title
typeset volume

n="\n"

notify-send "${title}" "${album}${album:+${artist:+ by }}${artist}${${:-$artist$album}:+ (}${volume}%${${:-$artist$album}:+)}"
