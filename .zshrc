ZSH=$HOME/.oh-my-zsh
# ZSH_THEME="blinks"
ZSH_THEME="af-magic"

plugins=(git github lein)

ZDOTDIR=~/.cache/zsh

source $ZSH/oh-my-zsh.sh

# alias datomic-console="/usr/local/Cellar/datomic/0.9.5703/libexec/bin/console -p 8080 localhost datomic:free://localhost:4334/"

export GREP_OPTIONS="--color=auto"
export LANGUAGE='en_US.UTF-8 git'

eval "$(direnv hook zsh)"
