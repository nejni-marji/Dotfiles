#!/bin/zsh
set -o allexport
XDG_RUNTIME_DIR="/run/user/$(id -u)"
eval "$(systemctl --user show-environment)"
exec "$@"
