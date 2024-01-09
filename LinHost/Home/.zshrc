if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme
zle_highlight=("paste:none")

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

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
