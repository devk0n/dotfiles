# ~/.config/zsh/plugins.zsh

# Only load in interactive shells
[[ $- != *i* ]] && return

# Enable bash completion support inside zsh
autoload -Uz compinit bashcompinit
compinit
bashcompinit
