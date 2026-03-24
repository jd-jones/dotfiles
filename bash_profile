
# Homebrew (must be first so subsequent PATH additions layer on top)
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
