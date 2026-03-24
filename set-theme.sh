#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
VALID_THEMES=(
  "catppuccin/latte" "catppuccin/frappe" "catppuccin/macchiato" "catppuccin/mocha"
  "kanagawa/wave" "kanagawa/dragon"
  "tokyonight/moon"
)

if [ "${1:-}" = "" ]; then
  echo "Usage: set-theme.sh <family/variant>"
  echo "Available: ${VALID_THEMES[*]}"
  echo "Current:   $(cat "$DOTFILES/theme" 2>/dev/null || echo '(none)')"
  exit 0
fi

THEME="$1"

valid=false
for t in "${VALID_THEMES[@]}"; do
  [ "$t" = "$THEME" ] && valid=true && break
done
if [ "$valid" = false ]; then
  echo "Unknown theme: $THEME"
  echo "Available: ${VALID_THEMES[*]}"
  exit 1
fi

# Map family/variant to app-specific identifiers.
# NVIM_COLORSCHEME is the direct :colorscheme name (family-variant).
NVIM_COLORSCHEME="${THEME/\//\-}"

case "$THEME" in
  catppuccin/latte)
    VSCODE_THEME="Catppuccin Latte"
    ITERM_PRESET="Catppuccin Latte"
    ;;
  catppuccin/frappe)
    VSCODE_THEME="Catppuccin Frappe"
    ITERM_PRESET="Catppuccin Frappe"
    ;;
  catppuccin/macchiato)
    VSCODE_THEME="Catppuccin Macchiato"
    ITERM_PRESET="Catppuccin Macchiato"
    ;;
  catppuccin/mocha)
    VSCODE_THEME="Catppuccin Mocha"
    ITERM_PRESET="Catppuccin Mocha"
    ;;
  kanagawa/wave)
    VSCODE_THEME="Kanagawa"
    ITERM_PRESET="Kanagawa Wave"
    ;;
  kanagawa/dragon)
    VSCODE_THEME="Kanagawa"
    ITERM_PRESET="Kanagawa Dragon"
    ;;
  tokyonight/moon)
    VSCODE_THEME="Tokyo Night Moon"
    ITERM_PRESET="Tokyo Night Moon"
    ;;
esac

printf '%s\n' "$THEME" > "$DOTFILES/theme"
echo "Theme set to: $THEME"

# --- tmux ---
if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null 2>&1; then
  tmux source-file ~/.tmux.conf
  echo "  tmux reloaded."
fi

# --- Neovim (best-effort live reload; full effect requires restart) ---
find "${TMPDIR:-/tmp}" -name 'nvim.*.0' -type s 2>/dev/null | while read -r socket; do
  if nvim --server "$socket" --remote-send ":colorscheme ${NVIM_COLORSCHEME}<CR>" 2>/dev/null; then
    echo "  nvim reloaded: $socket"
  fi
done

# --- VSCode ---
# Handles JSONC (comments) by using regex replacement rather than JSON parsing.
# Checks Code, Code - Insiders, and Cursor.
_set_vscode_theme() {
  local settings="$1"
  local theme="$2"
  [ -f "$settings" ] || return 0
  python3 - "$settings" "$theme" <<'EOF'
import re, sys
path, theme = sys.argv[1], sys.argv[2]
with open(path, 'r') as f:
    content = f.read()
new_entry = f'"workbench.colorTheme": "{theme}"'
if re.search(r'"workbench\.colorTheme"\s*:', content):
    content = re.sub(r'"workbench\.colorTheme"\s*:\s*"[^"]*"', new_entry, content)
else:
    # Insert before the final closing brace
    content = re.sub(r'(\n?)(\s*)\}(\s*)$',
                     lambda m: f',\n  {new_entry}{m.group(1)}{m.group(2)}}}{ m.group(3)}',
                     content.rstrip())
with open(path, 'w') as f:
    f.write(content)
EOF
}

for app in "Code" "Code - Insiders" "Cursor"; do
  settings="$HOME/Library/Application Support/$app/User/settings.json"
  if [ -f "$settings" ]; then
    _set_vscode_theme "$settings" "$VSCODE_THEME"
    echo "  VSCode ($app) theme → $VSCODE_THEME"
  fi
done

# --- iTerm2 (macOS only; preset must be imported first via install/macos.sh) ---
if [ "$(uname)" = "Darwin" ] && command -v osascript &>/dev/null; then
  osascript > /dev/null 2>&1 <<APPLESCRIPT || echo "  iTerm2: could not switch preset (not running, or '$ITERM_PRESET' not imported yet)"
tell application "iTerm2"
  tell current session of current window
    set color preset to "$ITERM_PRESET"
  end tell
end tell
APPLESCRIPT
  echo "  iTerm2 preset → $ITERM_PRESET"
fi

echo "Done. Restart open nvim sessions for full effect."
