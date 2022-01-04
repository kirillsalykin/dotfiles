ZSH=$HOME/.oh-my-zsh
# ZSH_THEME="blinks"
ZSH_THEME="af-magic"

plugins=(brew direnv docker gcloud git helm history kubectl)

ZDOTDIR=~/.cache/zsh

source $ZSH/oh-my-zsh.sh

export GREP_OPTIONS="--color=auto"
export LANGUAGE='en_US.UTF-8 git'

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

source $HOME/private.sh
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
export PATH="/usr/local/opt/libpq/bin:$PATH"
