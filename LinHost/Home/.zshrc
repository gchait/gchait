if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme
zle_highlight=("paste:none")

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

SAVEHIST=1000
HISTFILE=~/.zsh_history

bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey ";3C" forward-word
bindkey ";3D" backward-word

export EDITOR=nvim
export PAGER=

alias ls='eza -a --color=always --group-directories-first'
alias ll='eza -al --color=always --group-directories-first'
alias lt='eza -aT --color=always --group-directories-first'
alias l.='eza -a | grep --color=never -E "^\."'

alias vi="nvim"
alias vim="nvim"
alias oldvim="\vim"
alias vimdiff="nvim -d"

alias d="docker"
alias k="kubectl"

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
