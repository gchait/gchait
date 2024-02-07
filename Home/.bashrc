export EDITOR=vim
export PAGER=

alias ls="eza -a --color=always --group-directories-first"
alias ll="eza -al --color=always --group-directories-first"
alias lt="eza -aT --color=always --group-directories-first"

alias d="docker"
alias k="kubectl"

[[ -f ~/.hidden_bashrc ]] && source ~/.hidden_bashrc

function set_title(){
    echo -ne "\033]0;$(basename "$PWD")\a"
}
starship_precmd_user_func="set_title"
eval "$(starship init bash)"
