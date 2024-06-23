if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

function precmd () {
  echo -ne "\033]0;${PWD##*/}\007"
}

SAVEHIST="1500"
HISTFILE="${HOME}/.zsh_history"

fpath=("${HOME}/.zsh/complete/src" ${fpath})
zle_highlight=("paste:none")

export EDITOR="vim"
export PAGER="less"

alias update="git -C ${HOME}/gchait pull && scoop update -a"
alias ff="fastfetch -c paleofetch.jsonc"
alias ls="eza -a --group-directories-first"
alias ll="ls -l"
alias lt="ls -T --git-ignore"
alias df="df -hT"
alias du="du -sh"

alias j="just"
alias d="docker"
alias k="kubectl"
alias c="code"
alias g="git"

bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[3~" delete-char

autoload -Uz compinit && compinit
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"

source "${HOME}/.zsh/highlight/zsh-syntax-highlighting.zsh"
source "${HOME}/.zsh/suggest/zsh-autosuggestions.zsh"
source "${HOME}/.zsh/p10k/powerlevel10k.zsh-theme"

[[ -f "${HOME}/.hidden_zshrc" ]] && source "${HOME}/.hidden_zshrc"
[[ -f "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"
