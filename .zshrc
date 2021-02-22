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

function vterm_printf(){
  if [ -n "$TMUX" ]; then
    # Tell tmux to pass the escape sequences through
    # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
    printf "\ePtmux;\e\e]%s\007\e\\" "$1"
  elif [ "${TERM%%-*}" = "screen" ]; then
    # GNU screen (screen, screen-256color, screen-256color-bce)
    printf "\eP\e]%s\007\e\\" "$1"
  else
    printf "\e]%s\e\\" "$1"
  fi
}

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
  alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi

eval "$(direnv hook zsh)"

alias flux-prod-eu="cd ~/projects/lemonpi/lemonpi-infra/flux/prod/eu-west-1-kube-02"
alias flux-test-eu="cd ~/projects/lemonpi/lemonpi-infra/flux/test/eu-west-1-kube-02"
