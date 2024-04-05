SAVEHIST=1000
HISTFILE=~/.zsh_history

zle_highlight=("paste:none")
fpath+=($HOME/.zsh/pure)

export EDITOR=vim
export PAGER=more

alias sudo="sudo "
alias zyp="zypper"
alias flat="flatpak"
alias update="~/.update.sh"
alias ff="fastfetch -c paleofetch.jsonc"
alias ls="eza -a --group-directories-first"
alias ll="ls -l"
alias lt="ls -T"
alias df="df -hT"
alias j="just"
alias d="docker"
alias k="kubectl"
alias c="code"
alias g="git"

[[ -f ~/.hidden_zshrc ]] && source ~/.hidden_zshrc
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[3~" delete-char

autoload -Uz compinit && compinit
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"

autoload -U promptinit && promptinit
prompt pure
