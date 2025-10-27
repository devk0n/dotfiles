# ~/.config/zsh/aliases.zsh

# --- File listing ---
alias ls='ls --color=auto -A'      # show hidden files (skip . and ..)
alias ll='ls -lhAX --color=auto'   # long, human-readable, grouped by extension

# --- Search ---
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# --- Safer file operations ---
alias cp='cp -i'   # confirm before overwrite
alias mv='mv -i'
alias rm='rm -i'

# --- Convenience ---
alias aliases='nvim ~/.config/zsh/aliases.zsh'
alias path='echo -e ${PATH//:/\\n}'   # pretty-print $PATH
