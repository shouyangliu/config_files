# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
export PATH="$HOME/flutter/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

# Colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Enable color completion
complete -cf sudo
complete -cf man

# Git completion
if [ -f /usr/share/bash-completion/completions/git ]; then
    source /usr/share/bash-completion/completions/git
fi

# Prompt with git status and icons
parse_git_status() {
    git rev-parse --git-dir >/dev/null 2>&1 || return
    
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    [ -z "$branch" ] && branch=$(git rev-parse --short HEAD 2>/dev/null)
    [ -z "$branch" ] && return
    
    local status=$(git status --porcelain 2>/dev/null)
    local staged unstaged untracked
    
    staged=$(echo "$status" | grep -c "^[MADRC]" || true)
    unstaged=$(echo "$status" | grep -c "^.[MADRC]" || true)
    untracked=$(echo "$status" | grep -c "^??" || true)
    
    local icon="📂"
    [ -n "$status" ] && icon="📁"
    
    local info=""
    [ "$staged" -gt 0 ] && info+="+${staged} "
    [ "$unstaged" -gt 0 ] && info+="~${unstaged} "
    [ "$untracked" -gt 0 ] && info+="?${untracked} "
    
    echo " $icon $branch${info:+ [$info]}"
}

PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[1;31m\]$(parse_git_status)\[\033[0m\]\$ '

# Aliases
if command -v eza &>/dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons'
    alias la='eza -la --icons'
fi
