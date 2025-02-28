#!/usr/bin/env bash

for folder in $(ls -d */ | cut -f1 -d '/'); do
  echo ""
  echo "stow $folder"
  stow -R -v $folder
done

echo ""
echo "DONE"
