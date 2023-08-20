if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme
zle_highlight=("paste:none")

export EDITOR=nvim
export PAGER=

alias ls='exa -a --color=always --group-directories-first'
alias ll='exa -al --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'
alias ldot='exa -a | grep -E "^\."'

alias vi="nvim"
alias vim="nvim"
alias oldvim="\vim"
alias vimdiff="nvim -d"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
