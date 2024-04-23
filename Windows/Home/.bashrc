[[ $- != *i* ]] && return

export HISTCONTROL=ignoredups:erasedups
export EDITOR=vim

alias update="git -C ~/gchait pull && scoop update -a"
alias ff="fastfetch -c paleofetch.jsonc"
alias ls="eza -a --group-directories-first"
alias ll="ls -l"
alias lt="ls -T"
alias df="df -hT"
alias du="du -sh"

shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s dotglob
shopt -s histappend
shopt -s expand_aliases
shopt -s checkwinsize

bind "set completion-ignore-case on"

function set_title(){
    echo -ne "\033]0;$(basename "$PWD")\a"
}
starship_precmd_user_func="set_title"
eval "$(starship init bash)"
