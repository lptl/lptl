#!/usr/bin/env bash
set -e

DOOM_DIR="$HOME/.config/emacs"

if [ -d "$DOOM_DIR" ] && [ -x "$DOOM_DIR/bin/doom" ]; then
  echo "Doom Emacs found at $DOOM_DIR — upgrading..."
  "$DOOM_DIR/bin/doom" upgrade
else
  echo "Doom Emacs not found, installing fresh..."
  git clone --depth 1 https://github.com/doomemacs/doomemacs "$DOOM_DIR"
  "$DOOM_DIR/bin/doom" install
fi

rm -rf ~/.config/nvim
rm -rf ~/.doom.d
ln -s ./.doom.d/ ~/.doom.d/
ln -s ./nvim ~/.config/nvim
"$DOOM_DIR/bin/doom" sync
