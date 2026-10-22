#!/usr/bin/env bash

# Packages targeting $HOME are stowed. Packages targeting system dirs
# (e.g. /etc/pam.d) are copied as root-owned files instead, so root never
# reads config through a symlink into a user-writable repo.

for folder in $(ls -d */ | cut -f1 -d '/'); do
  target=$HOME
  if [ -e "$folder/.target" ]; then
    eval "target=$(cat "$folder/.target")"
  fi

  echo ""
  if [[ "$target" == "$HOME"* ]]; then
    echo "stow $folder"
    ./stow.sh $folder
    continue
  fi

  echo "copy $folder -> $target"
  for file in $(cd "$folder" && find . -type f ! -name .target -printf '%P\n'); do
    dest="${target%/}/$file"
    if cmp -s "$folder/$file" "$dest"; then
      echo "unchanged $dest"
      continue
    fi
    diff -u "$dest" "$folder/$file" 2>/dev/null
    sudo install -D -m 644 -o root -g root "$folder/$file" "$dest" && echo "installed $dest"
  done
done

echo ""
echo "DONE"
