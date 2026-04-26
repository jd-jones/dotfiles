#!/usr/bin/env bash
set -euo pipefail

echo "Installing apt packages..."
sudo apt-get update -q
sudo apt-get install -y curl git build-essential tmux ripgrep fd-find nodejs npm unzip mosh

# On Debian/Ubuntu, fd is packaged as fdfind. Symlink it for Telescope compatibility.
if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
  mkdir -p ~/.local/bin
  ln -sf "$(which fdfind)" ~/.local/bin/fd
  echo "  Linked fdfind -> ~/.local/bin/fd"
  echo "  Ensure ~/.local/bin is in your PATH."
fi

echo "Installing Neovim (latest stable)..."
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
  NVIM_TARBALL="nvim-linux-x86_64.tar.gz"
  NVIM_DIR="nvim-linux-x86_64"
elif [ "$ARCH" = "aarch64" ]; then
  NVIM_TARBALL="nvim-linux-arm64.tar.gz"
  NVIM_DIR="nvim-linux-arm64"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

TMP=$(mktemp -d)
curl -Lo "$TMP/$NVIM_TARBALL" \
  "https://github.com/neovim/neovim/releases/latest/download/$NVIM_TARBALL"
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf "$TMP/$NVIM_TARBALL"
sudo ln -sf "/opt/$NVIM_DIR/bin/nvim" /usr/local/bin/nvim
rm -rf "$TMP"
echo "  Neovim $(nvim --version | head -1) installed."

echo "Installing JetBrainsMono Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts/JetBrainsMono"
mkdir -p "$FONT_DIR"
TMP=$(mktemp -d)
curl -Lo "$TMP/JetBrainsMono.zip" \
  "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
unzip -q -o "$TMP/JetBrainsMono.zip" -d "$FONT_DIR"
fc-cache -fv
rm -rf "$TMP"

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

echo ""
echo "Debian setup complete."
echo "Next steps:"
echo "  1. Set 'JetBrainsMono Nerd Font' as your terminal font for icons to render."
echo "  2. Open nvim — lazy.nvim will install plugins on first launch."
echo "  3. Run :Mason inside nvim to manage LSP servers."
