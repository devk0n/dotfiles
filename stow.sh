#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Stowing dotfiles from $DOTFILES_DIR"

# Common junk/cache files to ignore
IGNORE_PATTERNS="--ignore='^\\.zcompdump$'"

for pkg in "$DOTFILES_DIR"/*; do
  [ -d "$pkg" ] || continue
  name="$(basename "$pkg")"

  case "$name" in
    cmake)
      echo "→ $name (to ~/.cmake)"
      mkdir -p "$HOME/.cmake"
      stow -v -R $IGNORE_PATTERNS -t "$HOME/.cmake" "$name"
      ;;
    *)
      echo "→ $name (to ~/.config/$name)"
      mkdir -p "$HOME/.config/$name"
      stow -v -R $IGNORE_PATTERNS -t "$HOME/.config/$name" "$name"
      ;;
  esac
done

echo "Done!"
