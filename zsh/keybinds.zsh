# ================================
# Enable vi mode
# ================================
bindkey -v   # use vi keybindings

# ================================
# Insert mode (viins)
# ================================
bindkey -M viins '^[[3~' delete-char              # Delete
bindkey -M viins '^?' backward-delete-char        # Backspace
bindkey -M viins '^H' backward-delete-char        # Ctrl-H as backspace

bindkey -M viins '^A' beginning-of-line           # Ctrl-A → start of line
bindkey -M viins '^E' end-of-line                 # Ctrl-E → end of line
bindkey -M viins '^U' backward-kill-line          # Ctrl-U → clear line
bindkey -M viins '^W' backward-kill-word          # Ctrl-W → delete word

# Home/End/PgUp/PgDn (common escapes)
bindkey -M viins '^[[1~' beginning-of-line
bindkey -M viins '^[[4~' end-of-line
bindkey -M viins '^[[5~' history-beginning-search-backward
bindkey -M viins '^[[6~' history-beginning-search-forward

# ================================
# Command/normal mode (vicmd)
# ================================
bindkey -M vicmd '^[[3~' delete-char              # Delete key
bindkey -M vicmd 'D' kill-line                    # D → delete to EOL
bindkey -M vicmd 'C' change-line                  # C → change to EOL
bindkey -M vicmd 'x' delete-char                  # x → delete char
bindkey -M vicmd 'r' overwrite-mode               # r → replace mode

# ================================
# Visual mode (visual)
# ================================
bindkey -M visual '^[[3~' kill-region             # Delete = delete selection
bindkey -M visual '^?' kill-region                # Backspace = delete selection
bindkey -M visual '^H' kill-region
bindkey -M visual 'd' kill-region                 # d → delete selection
bindkey -M visual 'y' copy-region-as-kill         # y → yank selection

# ================================
# Cursor shape indicator
# ================================
function zle-keymap-select {
  case $KEYMAP in
    vicmd) echo -ne '\e[2 q' ;;   # block cursor (normal mode)
    viins|main) echo -ne '\e[6 q' ;; # beam cursor (insert mode)
  esac
}
zle -N zle-keymap-select
zle-keymap-select

# Restore cursor on new line/init
function zle-line-init() { zle-keymap-select }
zle -N zle-line-init
