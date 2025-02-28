#! /usr/bin/env bash

package=$1

if [ -e "$package/.target" ]; then
  target_expression=$(cat "$package/.target")
  eval "target=$target_expression"
else
  target=$HOME
fi
stow -D -v --target="$target" $package
