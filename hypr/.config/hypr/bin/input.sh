#!/bin/sh

toggle_input() {
  # Get current input method
  current=$(fcitx5-remote -n)

  # Toggle between bamboo and keyboard-us
  if [ "$current" = "bamboo" ]; then
    fcitx5-remote -s keyboard-us
  else
    fcitx5-remote -s bamboo
  fi
}

# Execute the toggle function when script is called
toggle_input
