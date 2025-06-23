#!/bin/sh

. "${HOME}/.config/hypr/bin/menu/opts.sh"

cd /mnt/steam/SteamLibrary/steamapps &&
  for acf in *.acf; do
    appid=$(grep '"appid"' "$acf" | head -n1 | grep -o '[0-9]\+')
    installdir=$(grep '"installdir"' "$acf" | head -n1 | sed -E 's/.*"installdir"\s+"(.*)"/\1/')
    echo "[$appid] $installdir"
  done |
  sort |
  bemenu "${OPTS[@]}" --prompt "Steam" |
  while read -r line; do
    appid=$(echo "$line" | grep -oP '\[\K[0-9]+')
    echo "Launching App ID: $appid"
    steam "steam://rungameid/$appid"
  done
