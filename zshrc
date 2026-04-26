# Source global definitions
[ -f /etc/zshrc ] && source /etc/zshrc

# Prompt — green %#> (% for normal user, # for root), full path with ~, short hostname
autoload -U colors && colors
PROMPT='
(%D %@) %n @ %m :: %~
%F{green}%#>%f '

# Shared environment
[ -f "$HOME/.env.sh" ] && source "$HOME/.env.sh"

export PATH="$HOME/bin:$PATH"
