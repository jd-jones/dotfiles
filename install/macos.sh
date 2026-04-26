#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Install it from https://brew.sh and re-run."
  exit 1
fi

echo "Installing packages via Homebrew..."
brew install neovim tmux git ripgrep fd node mosh

# Nerd Font — set "JetBrainsMono Nerd Font" in your terminal emulator afterwards
brew install --cask font-jetbrains-mono-nerd-font || \
  echo "  Warning: font install failed (network issue?). Retry with: brew install --cask font-jetbrains-mono-nerd-font"

bash "$(dirname "$0")/symlinks.sh"

# tmux plugins (cloned to ~/.config/tmux/plugins/)
_clone_or_update() {
  if [ -d "$2/.git" ]; then
    git -C "$2" pull --quiet && echo "  updated: $2"
  else
    git clone --depth=1 "$1" "$2" && echo "  cloned: $2"
  fi
}
echo "Installing tmux plugins..."
mkdir -p ~/.config/tmux/plugins
_clone_or_update https://github.com/catppuccin/tmux              ~/.config/tmux/plugins/catppuccin/tmux
_clone_or_update https://github.com/tmux-plugins/tmux-cpu        ~/.config/tmux/plugins/tmux-plugins/tmux-cpu
_clone_or_update https://github.com/tmux-plugins/tmux-battery    ~/.config/tmux/plugins/tmux-plugins/tmux-battery
_clone_or_update https://github.com/Nybkox/tmux-ukiyo            ~/.config/tmux/plugins/Nybkox/tmux-ukiyo
_clone_or_update https://github.com/arcticicestudio/nord-tmux    ~/.config/tmux/plugins/arcticicestudio/nord-tmux

# VSCode extensions — all three theme variants
if command -v code &>/dev/null; then
  echo "Installing VSCode extensions..."
  code --install-extension catppuccin.catppuccin-vsc
  code --install-extension qufiwefefwoyn.kanagawa
  code --install-extension PatrickNasralla.tokyo-night-moon
  code --install-extension arcticicestudio.nord-visual-studio-code
fi

# iTerm2 color presets — opens each .itermcolors file so iTerm2 prompts to import.
# Required once before set-theme.sh can switch iTerm2 presets automatically.
DOTFILES="$(dirname "$0")/.."
if [ -d "/Applications/iTerm.app" ] || [ -d "$HOME/Applications/iTerm.app" ]; then
  echo "Importing iTerm2 color presets (confirm each import prompt)..."
  open "$DOTFILES/themes/catppuccin/Catppuccin Latte.itermcolors"
  open "$DOTFILES/themes/catppuccin/Catppuccin Frappe.itermcolors"
  open "$DOTFILES/themes/catppuccin/Catppuccin Macchiato.itermcolors"
  open "$DOTFILES/themes/catppuccin/Catppuccin Mocha.itermcolors"
  open "$DOTFILES/themes/kanagawa/Kanagawa Wave.itermcolors"
  open "$DOTFILES/themes/kanagawa/Kanagawa Dragon.itermcolors"
  open "$DOTFILES/themes/tokyonight/Tokyo Night Moon.itermcolors"
  open "$DOTFILES/themes/nord/Nord.itermcolors"
fi

echo ""
echo "macOS setup complete."
echo "Next steps:"
echo "  1. Set 'JetBrainsMono Nerd Font' as your terminal font for icons to render."
echo "  2. Open nvim — lazy.nvim will install plugins on first launch."
echo "  3. Run :Mason inside nvim to manage LSP servers."
echo "  4. Run ./set-theme.sh <catppuccin|kanagawa|tokyonight> to switch themes."
