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

test -f ~/.hidden_bashrc && . ~/.hidden_bashrc

function set_title(){
    echo -ne "\033]0;$(basename "$PWD")\a"
}
starship_precmd_user_func="set_title"
eval "$(starship init bash)"
