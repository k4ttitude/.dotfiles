#! /usr/bin/env bash

package=$1
if [ -z "$package" ]; then
  echo "Error: No package provided"
  exit 1
fi

if [ -e "$package/.target" ]; then
  target_expression=$(cat "$package/.target")
  eval "target=$target_expression"
else
  target=$HOME
fi

stow -D -v --target="$target" $package

# .mkdir: target dirs to create as real dirs before linking. Stow links the
# topmost dir that doesn't exist, so without this a missing
# ~/.config/omarchy/plugins would become a link into this repo and every
# plugin Omarchy installs later would land here. Runs after `stow -D` so a dir
# folded by an earlier stow is unlinked first instead of mkdir'd through.
if [ -e "$package/.mkdir" ]; then
  while read -r dir || [ -n "$dir" ]; do
    [ -n "$dir" ] && mkdir -p "${target%/}/$dir"
  done <"$package/.mkdir"
fi

stow -S -v --target="$target" $package

# .copy/: files copied into the target instead of linked, for places that
# ignore symlinks (Omarchy skips them in themes cloned from a git repo).
# The destination dir must already exist: a themes/artzen holding only
# colors.toml would show up as a broken theme. `omarchy theme install` wipes
# the dir before cloning, so rerun this after reinstalling a theme.
if [ -d "$package/.copy" ]; then
  for file in $(cd "$package/.copy" && find . -type f -printf '%P\n'); do
    dest="${target%/}/$file"
    cmp -s "$package/.copy/$file" "$dest" && continue
    if [ ! -d "$(dirname "$dest")" ]; then
      echo "SKIP: $file ($(dirname "$dest") missing, install it and rerun)"
      continue
    fi
    install -m 644 "$package/.copy/$file" "$dest" && echo "COPY: $file"
  done
fi
