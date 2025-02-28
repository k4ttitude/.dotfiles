mkdir -p "$1/.config" &&
  stow -D $1 &&
  mv "$1/.config/$1" "$HOME/.config" &&
  rm -r $1
