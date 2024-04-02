zle_highlight=("paste:none")

autoload -Uz compinit && compinit
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"

SAVEHIST=1000
HISTFILE=~/.zsh_history

bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[3~" delete-char

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

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -f ~/.hidden_zshrc ]] && source ~/.hidden_zshrc

fpath+=($HOME/.zsh/pure)
autoload -U promptinit && promptinit
prompt pure
