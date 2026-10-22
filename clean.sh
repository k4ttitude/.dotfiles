#!/usr/bin/env bash

# System packages (copied by install.sh) are left in place: removing
# files like /etc/pam.d/login would lock you out.

for folder in $(ls -d */ | cut -f1 -d '/'); do
  target=$HOME
  if [ -e "$folder/.target" ]; then
    eval "target=$(cat "$folder/.target")"
  fi

  echo ""
  if [[ "$target" != "$HOME"* ]]; then
    echo "skip $folder (system files in $target)"
    continue
  fi

  echo "unstow $folder"
  ./unstow.sh $folder
done

echo ""
echo "DONE"
