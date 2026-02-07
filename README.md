# Dotfiles Management Scripts

## Explanation

- **install.sh** - Loops through all directories and stows each one
- **clean.sh** - Loops through all directories and unstows each one
- **stow.sh** - Stows a single package, supports custom target via .target file
- **unstow.sh** - Unstows a single package, supports custom target via .target file
- **wots.sh** - Moves a config from ~/.config into a package structure and stows it
- **unwots.sh** - Reverses wots.sh - unstows, moves config back to home, removes package

## Examples

```bash
./install.sh              # Install all packages
./clean.sh                # Remove all packages
./stow.sh nvim            # Install nvim package
./unstow.sh nvim          # Remove nvim package
./wots.sh waybar          # Convert ~/.config/waybar to stow package
./unwots.sh waybar        # Convert stow package back to ~/.config/waybar
```
