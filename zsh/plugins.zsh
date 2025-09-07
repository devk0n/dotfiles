# ~/.config/zsh/plugins.zsh

# Only load in interactive shells
[[ $- != *i* ]] && return

### 1. Enable Zsh completion system ###
autoload -Uz compinit
compinit
