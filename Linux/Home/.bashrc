[[ $- != *i* ]] && return

export HISTCONTROL=ignoredups:erasedups
export EDITOR=vim
export PAGER=

alias ls="eza -a --group-directories-first"
alias ll="ls -l"
alias lt="ls -T"
alias df="df -hT"
alias ff="fastfetch"
alias j="just"
alias d="docker"
alias k="kubectl"

shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s dotglob
shopt -s histappend
shopt -s expand_aliases
shopt -s checkwinsize

bind "set completion-ignore-case on"
eval "$(starship init bash)"
