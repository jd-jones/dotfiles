# Source global definitions
[ -f /etc/bashrc ] && . /etc/bashrc

# Non-interactive shells (e.g. ssh remote-cmd) don't need a prompt or env setup
[[ $- == *i* ]] || return

unset PROMPT_COMMAND

# Prompt — matches zsh style: full path with ~, short hostname, green >
_green="\[$(tput setaf 2)\]"
_reset="\[$(tput sgr0)\]"
export PS1="\n(\d \@) \u @ \h :: \w\n${_green}>${_reset} "
unset _green _reset

# Shared environment
[ -f "$HOME/.env.sh" ] && . "$HOME/.env.sh"

export PATH="$HOME/bin:$PATH"
