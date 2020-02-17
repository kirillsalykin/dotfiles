ZSH=$HOME/.oh-my-zsh
# ZSH_THEME="blinks"
ZSH_THEME="af-magic"

plugins=(git github lein docker kubectl)

ZDOTDIR=~/.cache/zsh

source $ZSH/oh-my-zsh.sh

export GREP_OPTIONS="--color=auto"
export LANGUAGE='en_US.UTF-8 git'

export AWS_USER_NAME=kirill.salykin
export AWS_VAULT_BACKEND=keychain

sops () {
	aws-vault exec $AWS_PROFILE -- /usr/local/bin/sops $@
}

eval "$(direnv hook zsh)"
