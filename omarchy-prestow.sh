#!/usr/bin/env bash

# Omarchy writes its own defaults into ~/.config (hypr/*.lua, kitty.conf,
# opencode/, ...). Stow refuses to stow over real files, so move every one a
# $HOME package would replace into a backup dir. Run before ./install.sh.
#
#   ./omarchy-prestow.sh -n   # list what would move
#   ./omarchy-prestow.sh      # move it

dry_run=false
[ "$1" = "-n" ] && dry_run=true

repo=$(pwd -P)
backup="$HOME/omarchy-defaults-$(date +%Y%m%d-%H%M%S)"

for folder in $(ls -d */ | cut -f1 -d '/'); do
  # System packages are copied by install.sh, not stowed.
  [ -e "$folder/.target" ] && continue

  git ls-files "$folder" | cut -d/ -f2- | while read -r rel; do
    target="$HOME/$rel"
    [ -e "$target" ] || [ -L "$target" ] || continue

    # Already stowed from this repo.
    case "$(realpath -m "$target")" in "$repo"/*) continue ;; esac

    if $dry_run; then
      echo "would move ~/$rel"
      continue
    fi

    mkdir -p "$backup/$(dirname "$rel")"
    mv "$target" "$backup/$rel" && echo "moved ~/$rel -> $backup/$rel"
  done
done
