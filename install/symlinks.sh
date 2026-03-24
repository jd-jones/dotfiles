#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

symlink() {
  local src="$DOTFILES_DIR/$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "  $dst -> $src"
}

echo "Creating symlinks from $DOTFILES_DIR ..."

symlink env.sh        ~/.env.sh
symlink bashrc        ~/.bashrc
symlink bash_profile  ~/.bash_profile
symlink zshrc         ~/.zshrc
symlink zprofile      ~/.zprofile
symlink tmux.conf     ~/.tmux.conf
symlink nvim          ~/.config/nvim

echo "Symlinks created."
