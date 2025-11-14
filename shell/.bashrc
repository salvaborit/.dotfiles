# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# Custom exports, aliases, and functions
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# File system - eza-based ls replacement
if command -v eza &>/dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias ll='ls -lah'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
else
  # Fallback to standard ls if eza is not installed
  alias ls='ls -lh --color=auto'
  alias lsa='ls -lah'
fi

alias gg='lazygit'
alias gita='git add'
alias gitc='git commit -m'
alias gitac='git add . && git commit -m'
alias gitl='git log'
alias gitd='git diff'
alias gits='git status'
alias d='docker'
alias g='git'
alias p='sudo pacman'

alias pingpi='ping 192.168.1.12'

# claude code editor
export EDITOR='nvim'
alias n='nvim'

# show file system structure trees
alias dtree='tree -C -d --dirsfirst'
alias ftree='tree -C -L 5 --dirsfirst'

# starship

# get the current branch name
parse_git_branch() {
  git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
# check if the working directory is dirty
parse_git_dirty() {
  [[ -n "$(git status --porcelain 2>/dev/null)" ]] && echo "*"
}
export PS1='\u@\h \[\033[1;34m\]\w\[\033[0m\] \[\033[1;33m\]$(parse_git_branch)$(parse_git_dirty)\[\033[0m\] \$ '

# starship
eval "$(starship init bash)"
export STARSHIP_CONFIG=~/.config/starship.toml

export PATH="$HOME/.local/bin:$PATH"
