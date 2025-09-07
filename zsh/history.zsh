# Ensure XDG fallback is set
: "${XDG_STATE_HOME:=$HOME/.local/state}"

# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# Now mkdir is safe
mkdir -p "$XDG_STATE_HOME/zsh"
