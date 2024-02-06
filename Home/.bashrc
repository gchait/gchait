export EDITOR=vim
export PAGER=

alias ls="eza -a --color=always --group-directories-first"
alias ll="eza -al --color=always --group-directories-first"
alias lt="eza -aT --color=always --group-directories-first"

alias d="docker"
alias k="kubectl"

[[ -f ~/.hidden_bashrc ]] && source ~/.hidden_bashrc
