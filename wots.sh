mkdir -p "$1/.config"
mv "$HOME/.config/$1" "$1/.config"
stow -v $1
