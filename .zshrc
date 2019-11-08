ZSH=$HOME/.oh-my-zsh
# ZSH_THEME="blinks"
ZSH_THEME="af-magic"

plugins=(git github lein)

ZDOTDIR=~/.cache/zsh

source $ZSH/oh-my-zsh.sh

export GREP_OPTIONS="--color=auto"
export LANGUAGE='en_US.UTF-8 git'

eval "$(direnv hook zsh)"
