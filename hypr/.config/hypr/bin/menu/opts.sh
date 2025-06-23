#!/bin/sh

FONT="MesloLGM 11"
TEAL=#14b8a6

OPTS=(
  -c
  --width-factor 0.2
  --fixed-height
  --list 10
  --ignorecase
  --fn "$FONT"
  --line-height 22
  --tf $TEAL
  --hf $TEAL
)
