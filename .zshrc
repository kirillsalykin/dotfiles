ZSH=$HOME/.oh-my-zsh
ZSH_THEME="blinks"

plugins=(brew git github boot lein)

source $ZSH/oh-my-zsh.sh

alias flowb="cd ~/Projects/flow/backend"
alias flowf="cd ~/Projects/flow/frontend"

alias datomic-console="/usr/local/Cellar/datomic/0.9.5703/libexec/bin/console -p 8080 localhost datomic:free://localhost:4334/"

export GREP_OPTIONS="--color=auto"

eval "$(rbenv init -)"
