ZSH=$HOME/.oh-my-zsh
ZSH_THEME="blinks"

plugins=(brew git github lein)

source $ZSH/oh-my-zsh.sh

# alias datomic-console="/usr/local/Cellar/datomic/0.9.5703/libexec/bin/console -p 8080 localhost datomic:free://localhost:4334/"

compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION

export GREP_OPTIONS="--color=auto"
export LANGUAGE='en_US.UTF-8 git'

eval "$(direnv hook zsh)"
