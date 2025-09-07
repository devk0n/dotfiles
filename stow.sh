#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Stowing dotfiles into ~/.config from $DOTFILES_DIR"

for pkg in "$DOTFILES_DIR"/*; do
  [ -d "$pkg" ] || continue
  name="$(basename "$pkg")"
  echo "→ $name"
  mkdir -p "$HOME/.config/$name"
  stow -v -R -t "$HOME/.config/$name" "$name"
done

echo "Done!"

