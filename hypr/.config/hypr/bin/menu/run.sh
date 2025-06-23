#!/bin/sh

. "${HOME}/.config/hypr/bin/menu/opts.sh"

exec /usr/bin/bemenu-run "${OPTS[@]}" --prompt 'Run>'
