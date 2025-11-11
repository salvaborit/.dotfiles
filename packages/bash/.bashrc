# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

alias l='ls -lh'
alias ll='ls -lah'

alias gg='lazygit'
alias gita='git add'
alias gitc='git commit -m'
alias gitac='git add . && git commit -m'
alias gitl='git log'
alias gitd='git diff'
alias gits='git status'
alias d='docker'
alias g='git'

alias pingpi='ping 192.168.1.12'

# claude code editor
export EDITOR='vim'


# show file system structure trees
alias dtree='tree -C -d --dirsfirst'
alias ftree='tree -C -L 5 --dirsfirst'


# starship

# get the current branch name
parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
# check if the working directory is dirty
parse_git_dirty() {
  [[ -n "$(git status --porcelain 2> /dev/null)" ]] && echo "*"
}
export PS1='\u@\h \[\033[1;34m\]\w\[\033[0m\] \[\033[1;33m\]$(parse_git_branch)$(parse_git_dirty)\[\033[0m\] \$ '

# starship
eval "$(starship init bash)"
export STARSHIP_CONFIG=~/.config/starship.toml

export PATH="$HOME/.local/bin:$PATH"

