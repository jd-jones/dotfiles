# Shared environment — sourced by both bashrc and zshrc via ~/.env.sh symlink.

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Local binaries (fd symlink on Debian, user-installed tools)
export PATH="$HOME/.local/bin:$PATH"

# macOS: Homebrew binutils
[ -d "/opt/homebrew/opt/binutils/bin" ] && \
  export PATH="$PATH:/opt/homebrew/opt/binutils/bin"

# Zephyr SDK (arm target)
[ -d "$HOME/zephyr-sdk-0.17.1/arm-zephyr-eabi/bin" ] && \
  export PATH="$PATH:$HOME/zephyr-sdk-0.17.1/arm-zephyr-eabi/bin"

# STM32CubeMX
[ -d "/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources" ] && \
  export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources

export CLICOLOR=1

# fzf key bindings and fuzzy completion
if command -v fzf &>/dev/null; then
  # fzf >= 0.48 supports --bash / --zsh flags; fall back to sourcing shell-specific files
  if [ -n "$ZSH_VERSION" ]; then
    source <(fzf --zsh) 2>/dev/null || true
  elif [ -n "$BASH_VERSION" ]; then
    eval "$(fzf --bash)" 2>/dev/null || true
  fi
fi
