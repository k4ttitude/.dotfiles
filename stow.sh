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
stow -S -v --target="$target" $package
