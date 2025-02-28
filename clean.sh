#!/usr/bin/env bash

for folder in $(ls -d */ | cut -f1 -d '/'); do
  echo ""
  echo "unstow $folder"
  ./unstow.sh $folder
done

echo ""
echo "DONE"
