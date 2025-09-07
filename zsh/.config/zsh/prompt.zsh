# ~/.config/zsh/prompt.zsh
setopt prompt_subst

git_info() {
  local b dirty
  b=$(git symbolic-ref --short -q HEAD 2>/dev/null) || return 0
  if ! git diff --quiet --ignore-submodules -- 2>/dev/null ||
     ! git diff --cached --quiet --ignore-submodules -- 2>/dev/null; then
    dirty="*"   # keep it yellow too
  fi
  print -r " %F{yellow}(${b}${dirty})%f"
}

PROMPT='%F{cyan}%~%f$(git_info) ❯ '
