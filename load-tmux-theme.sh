#!/usr/bin/env bash
# Called by tmux.conf via run-shell. Reads the `theme` file (format: "family/variant",
# e.g. "catppuccin/mocha"), sets the appropriate plugin option, then sources the
# per-family tmux.conf.
# $0 is always this script's absolute path when invoked by tmux, so dirname reliably
# finds the dotfiles root.
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
THEME=$(cat "$DOTFILES/theme" 2>/dev/null | tr -d '[:space:]')
FAMILY="${THEME%%/*}"
VARIANT="${THEME##*/}"
THEME_CONF="$DOTFILES/themes/$FAMILY/tmux.conf"

if [ -f "$THEME_CONF" ]; then
  case "$FAMILY" in
    catppuccin)
      tmux set-option -gq @catppuccin_flavor "$VARIANT"
      ;;
    nord)
      ;;  # nord-tmux is static — no plugin variables needed
    *)
      tmux set-option -gq @ukiyo-theme "$THEME"
      ;;
  esac
  tmux source-file "$THEME_CONF"
else
  echo "load-tmux-theme: unknown theme '$THEME' (no file at $THEME_CONF)" >&2
fi
