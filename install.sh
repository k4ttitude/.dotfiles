#!/usr/bin/env bash

for folder in $(ls -d */ | cut -f1 -d '/'); do
  echo ""
  echo "stow $folder"
  if [ -e "$folder/.target" ]; then
    target_expression=$(cat "$folder/.target")
    eval "target=$target_expression"
  else
    target=$HOME
  fi
  stow -R -v --target="$target" $folder
done

echo ""
echo "DONE"
